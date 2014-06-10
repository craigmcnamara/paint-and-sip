ActiveAdmin.register Image, :as => "Image" do

  form do |f|
    f.inputs "Image", :multipart => true do
      if f.object.image
        f.input :image_name
        f.input :image, :as => :file, :hint => f.template.image_tag(f.object.thumbnail("400x400").url)
      else
        f.input :image, :as => :file
      end
    end

    # Has Many
    # f.has_many :items do |item|
    #   item.input :quantity
    #   item.input :price_per_piece
    # end

    f.actions
  end

  index do
    column "Preview", proc{ |image| image_tag(image.thumbnail("100x100").url) }
    column :image_name
    default_actions
  end

  show do
    h3 image.image_name
    div do
      simple_format image_tag image.thumbnail("400x400").url
    end
  end
end