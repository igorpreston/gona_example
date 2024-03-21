class CreateOnboardingTransitions < ActiveRecord::Migration[7.0]
  def change
    create_table :onboarding_transitions do |t|
      t.string :to_state, null: false
      t.jsonb :metadata, default: {}
      t.integer :sort_key, null: false
      t.integer :onboarding_id, null: false
      t.boolean :most_recent, null: false

      # If you decide not to include an updated timestamp column in your transition
      # table, you'll need to configure the `updated_timestamp_column` setting in your
      # migration class.
      t.timestamps null: false
    end

    # Foreign keys are optional, but highly recommended
    add_foreign_key :onboarding_transitions, :onboardings

    add_index(:onboarding_transitions,
              %i(onboarding_id sort_key),
              unique: true,
              name: "index_onboarding_transitions_parent_sort")
    add_index(:onboarding_transitions,
              %i(onboarding_id most_recent),
              unique: true,
              where: "most_recent",
              name: "index_onboarding_transitions_parent_most_recent")
  end
end
