ActiveAdmin.register Registration do

  scope :all
  scope :has_living_social_code

  csv do
    column :email
    column :quantity
    column("Event") { |reg| "#{reg.event.title} on #{reg.event.from.strftime("%Y-%m-%e %l:%M %p") if reg.event.from }" if reg.event }
    column :phone_number
    column :living_social_code
    column("Charged Total") { |reg| number_to_currency(reg.charged_in_dollars) }
    column :created_at
  end

  index do
    column :email
    column :phone_number
    column :party_name
    column :quantity
    column "Event", proc{ |reg| link_to("#{reg.event.title} on #{reg.event.from.strftime("%Y-%m-%e %l:%M %p") if reg.event.from }", admin_event_path(reg.event)) if reg.event }
    column :living_social_code
    column "Charged Total", proc{ |reg| number_to_currency(reg.charged_in_dollars) }
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :event, :collection => Event.upcoming
      f.input :email
      f.input :notes
      f.input :party_name
    end

    f.actions
  end
end
