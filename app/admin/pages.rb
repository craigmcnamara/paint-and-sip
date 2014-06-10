ActiveAdmin.register Page do

  index do
    column :name
    column :publish
    column :position
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :position
      f.input :publish, as: :boolean
    end
    f.inputs "Content" do
      f.input :body, as: :text
    end
    f.actions
  end
end