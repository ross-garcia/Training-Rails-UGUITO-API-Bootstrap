ActiveAdmin.register Book do
  includes :utility, :user
  permit_params :title, :author, :genre, :image, :publisher, :year, :utility_id, :user_id

  config.per_page = 5

  index do
    selectable_column
    id_column
    column 'User' do |book|
      "#{book.user.first_name} #{book.user.last_name}"
    end
    column :utility
    column :title
    column :author
    column :genre
    actions
  end

  filter :title
  filter :author
  filter :genre
  filter :utility, as: :select, collection: Utility.all.map { |utility|
    [utility.name, utility.id]
  }
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Book Details', allow_destroy: true do
      f.semantic_errors(*f.object.errors.keys)
      f.input :title
      f.input :author
      f.input :genre
      f.input :image, as: :url
      f.input :publisher
      f.input :year
      f.input :user_id, label: 'User', as: :select, collection: User.all.map { |user|
        ["#{user.first_name} #{user.last_name}", user.id]
      }
      f.input :utility_id, label: 'Utility', as: :select, collection: Utility.all.map { |utility|
        [utility.type, utility.id]
      }
      f.actions
    end
  end
end
