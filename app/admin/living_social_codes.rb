ActiveAdmin.register LivingSocialCode, as: "GiftCode" do
  scope :claimed
  scope :unclaimed
  scope :associated
  scope :unassociated

  filter :sales_associate
  filter :bucket

  index do
    column :code
    column :type
    column :bucket
    column :updated_at
    column :registration_id
    column :sales_associate
  end

  csv do
    column :code
    column :bucket
    column :registration_id
    column :sales_associate
  end

  form do |f|
    f.inputs do
      f.input :sales_associate
      f.input :count, collection: [50, 250, 500]
      f.input :bucket, collection: [['One Seats', 'one'], ['Two Seats', 'two']]
    end
    f.actions
  end

  controller do
    def create
      LivingSocialCode.create_batch!(params[:gift_code])
      redirect_to admin_gift_codes_path(params.slice(:sales_associate_id))
    end
  end
end