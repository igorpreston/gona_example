module ApplicationHelper
  include Pagy::Frontend

  def react_component(name, *_args, **kwargs, &block)
    path = Dir.glob("components/**/#{name}.{jsx,tsx}", base: 'app/frontend')

    return nil if path.blank? || path.first.nil?

    data = {
      controller: 'react',
      react_name_value: name,
      react_path_value: path.first.prepend('/'),
      react_props_value: kwargs.with_indifferent_access.deep_transform_keys { |key| key.camelize(:lower) }
    }

    content_tag :div, nil, data:, &block
  end

  def view_component(name, *args, **kwargs, &block)
    raise ArgumentError, 'View component name must be a String' unless name.is_a?(String)

    path = Rails.root.join('app', 'components', "#{name}.rb")

    raise ArgumentError, "View component with path '#{name}' does not exist" unless File.exist?(path)

    component = "#{name.downcase.classify}Component".constantize

    render component.new(*args, **kwargs, &block)
  end

  def readable_order_number(number)
    number.gsub(/(.{3})(?=.)/, '\1 ')
  end
end
