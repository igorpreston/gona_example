class RenameUsersToMerchants < ActiveRecord::Migration[7.1]
  def up
    remove_index :users, name: 'index_users_on_invited_by' if index_exists?(:users, 'index_users_on_invited_by')
    remove_index :users, name: 'index_users_on_invited_by_id' if index_exists?(:users, 'index_users_on_invited_by_id')

    rename_table :users, :merchants

    if index_exists?(:merchants, 'index_merchants_on_invited_by_id')
      add_index :merchants, :invited_by_id, name: 'index_merchants_on_invited_by_id'
    end

    if index_exists?(:merchants, 'index_merchants_on_invited_by')
      add_index :merchants, %i[invited_by_type invited_by_id], name: 'index_merchants_on_invited_by'
    end

    if index_exists?(:merchants, 'index_users_on_email')
      rename_index :merchants, 'index_users_on_email', 'index_merchants_on_email'
    end
    if index_exists?(:merchants, 'index_users_on_invitation_token')
      rename_index :merchants, 'index_users_on_invitation_token', 'index_merchants_on_invitation_token'
    end
    if index_exists?(:merchants, 'index_users_on_organization_id')
      rename_index :merchants, 'index_users_on_organization_id', 'index_merchants_on_organization_id'
    end
    if index_exists?(:merchants, 'index_users_on_phone')
      rename_index :merchants, 'index_users_on_phone', 'index_merchants_on_phone'
    end
    return unless index_exists?(:merchants, 'index_users_on_stripe_customer_id')

    rename_index :merchants, 'index_users_on_stripe_customer_id', 'index_merchants_on_stripe_customer_id'
  end

  def down
    rename_table :merchants, :users

    if index_exists?(:users, 'index_merchants_on_email')
      rename_index :users, 'index_merchants_on_email', 'index_users_on_email'
    end
    if index_exists?(:users, 'index_merchants_on_invitation_token')
      rename_index :users, 'index_merchants_on_invitation_token', 'index_users_on_invitation_token'
    end
    if index_exists?(:users, 'index_merchants_on_invited_by')
      rename_index :users, 'index_merchants_on_invited_by', 'index_users_on_invited_by'
    end
    if index_exists?(:users, 'index_merchants_on_invited_by_id')
      rename_index :users, 'index_merchants_on_invited_by_id', 'index_users_on_invited_by_id'
    end
    if index_exists?(:users, 'index_merchants_on_organization_id')
      rename_index :users, 'index_merchants_on_organization_id', 'index_users_on_organization_id'
    end
    if index_exists?(:users, 'index_merchants_on_phone')
      rename_index :users, 'index_merchants_on_phone', 'index_users_on_phone'
    end
    return unless index_exists?(:users, 'index_merchants_on_stripe_customer_id')

    rename_index :users, 'index_merchants_on_stripe_customer_id', 'index_users_on_stripe_customer_id'
  end
end
