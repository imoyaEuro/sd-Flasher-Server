RailsAdmin.config do |config|

  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  #  config.authorize_with do
  #    redirect_to "/not_admin" unless warden.user.is_admin?
  #  end
  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  config.model 'Sale' do
    list do
      configure :updated_at do
        hide
      end
    end
  end

  config.model 'Package' do
    list do
      configure :created_at do
        hide
      end
      configure :updated_at do
        hide
      end
      configure :games do
        hide
      end
      configure :sales do
        hide
      end
      configure :logo do
        hide
      end

    end

    edit do
      group :default do
        label "Default group"
        field :name do
          label "Name"
        end
        field :description do
          label "Description"
        end
        field :price do
          label "Price"
        end
        field :logo do
          label "Logo"
        end
        field :games do
          label "Games"
        end
      end
    end

    show do
      group :default do
        label "Default group"
        field :name do
          label "Name"
        end
        field :description do
          label "Description"
        end
        field :price do
          label "Price"
        end
        field :games do
          label "Games"
        end
      end
    end
  end

  config.model 'Game' do
    list do 
      configure :packages do
        hide
      end
      configure :short_description do
        hide
      end
      configure :description do
        hide
      end
      configure :gamkey do
        hide
      end
      configure :apk_link do
        hide
      end
      configure :created_at do
        hide
      end
      configure :updated_at do
        hide
      end
      configure :logo do
        hide
      end
      configure :image1 do
        hide
      end
      configure :image2 do
        hide
      end
      configure :image3 do
        hide
      end
      configure :image4 do
        hide
      end
      configure :image5 do
        hide
      end
      configure :image6 do
        hide
      end
      configure :image7 do
        hide
      end
      configure :image8 do
        hide
      end
      configure :image9 do
        hide
      end
      configure :image10 do
        hide
      end
    end
  end

  config.model 'SdPackage' do
    list do
      configure :created_at do
        hide
      end
      configure :updated_at do
        hide
      end
      configure :sales do
        hide
      end
    end
    edit do
      group :default do
        label "Default group"
        field :key do
          label "Key"
        end
        field :tablet do
          label "Tablet"
        end
        field :provider do
          label "Provider"
        end
      end
    end

    show do
      group :default do
        label "Default group"
        field :key do
          label "Key"
        end
        field :tablet do
          label "Tablet"
        end
        field :provider do
          label "Provider"
        end
      end
    end
  end

  config.model 'PaperTrail::Version' do
    list do
      configure :whodunnit do
        hide
      end
      configure :object do
        hide
      end
      configure :transaction_id do
        hide
      end
      configure :ip do
        hide
      end
      configure :user_agent do
        hide
      end
      configure :version_associations do
        hide
      end
    end
  end



  config.model 'Provider' do
    list do
      configure :created_at do
        hide
      end
      configure :updated_at do
        hide
      end
      configure :api_token do
        hide
      end
      configure :sd_packages do
        hide
      end
      configure :sales do
        hide
      end
      configure :versions do
        hide
      end
    end
    edit do
      group :default do
        label "Default group"
        field :credit do
          label "Credit"
          partial "add_jquery_partial"
        end
        field :name do
          label "Name"
        end
        field :email do
          label "E-mail"
        end
      end
    end

    show do
      group :default do
        label "Default group"
        field :credit do
          label "Credit"
        end
        field :name do
          label "Name"
        end
        field :email do
          label "E-mail"
        end
        field :api_token do
          label "Api token"
        end
      end
    end

    #
  end


  #--------------
  #


  config.model 'User' do
    list do
      configure :created_at do
        hide
      end
      configure :updated_at do
        hide
      end
      configure :reset_password_sent_at do
        hide
      end
      configure :remember_created_at do
        hide
      end
      configure :sign_in_count do
        hide
      end
      configure :current_sign_in_count do
        hide
      end
      configure :current_sign_in_at do
        hide
      end
      configure :last_sign_in_at do
        hide
      end
      configure :current_sign_in_ip do
        hide
      end
      configure :last_sign_in_ip do
        hide
      end
    end
    edit do
      group :default do
        label "Default group"
        field :name do
          label "Name"
        end
        field :email do
          label "E-mail"
        end
        field :password do
          label "Password"
        end
        field :password_confirmation do
          label "Password confirmation"
        end
        field :roles_mask, :integer do
          optional false
          partial "roles_partial"
        end
      end
    end

    show do
      group :default do
        label "Default group"
        field :name do
          label "Name"
        end
        field :email do
          label "E-mail"
        end
      end
    end

    #
  end
  #--------------

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    history_index
    history_show
  end
end
