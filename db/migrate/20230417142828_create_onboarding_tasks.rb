class CreateOnboardingTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :onboarding_tasks do |t|
      t.references :onboarding, null: false, foreign_key: true, index: true
      t.string :template, null: false
      t.string :category, null: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
