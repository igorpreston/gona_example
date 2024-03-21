class Operation
  include AfterCommitEverywhere

  attr_reader :params, :response, :status

  def to_s
    "#{self.class.name}::Operation"
  end

  def success?
    return nil if @status.blank?

    @status == 'success'
  end

  def failure?
    return nil if @status.blank?

    @status == 'failure'
  end

  class Params < Dry::Struct
    transform_keys(&:to_sym)
  end

  class Response < Dry::Struct
    transform_keys(&:to_sym)
  end

  module ParamsHandler
    def initialize(**kwargs)
      @params = self.class.const_get(:Params).new(kwargs.deep_symbolize_keys)

      super()
    end
  end

  module ResponseHandler
    def perform
      response = super()

      @response = self.class.const_get(:Response).new(response.to_h.deep_symbolize_keys)

      @status = 'success'
      @record.update!(status: @status, response: @response)

      @response
    end
  end

  module TransactionHandler
    def perform
      transactional = proc { super() }

      begin
        ActiveRecord::Base.transaction(&transactional)
      rescue => e
        @status = 'failure'
        @response = { error: true, klass: e.class, message: e.message }
        @record.update!(status: @status, response: @response)
      end
    end
  end

  module PerformHandler
    def perform
      @record = OperationRecord.create!(name: self.class.name, params:)

      super()
    end
  end

  def self.inherited(klass)
    klass.prepend(ParamsHandler)
    klass.prepend(ResponseHandler)
    klass.prepend(TransactionHandler)
    klass.prepend(PerformHandler)
  end
end
