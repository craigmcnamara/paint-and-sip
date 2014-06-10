ActiveAdmin.register Event, :as => "Event" do
  filter :from, :as => :date_range

  scope :upcoming, :default => true
  scope :archive

  csv do
    column :title
    column :from
    column :artist
    column("total_registered"){ |event| event.total_registered }
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :venue, :collection => Venue.all
      f.input :artist, :colletion => Artist.all
      f.input :image, :collection => Image.all
      f.input :over_21
      f.input :private_event
      f.input :allow_registration
      f.input :seats
      f.input :seat_cost
      f.input :from, :as => :just_datetime_picker, :hint => "24 hour time format Ex: 6:30pm is 18:30"
      f.input :duration, :collection => [1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5].map{ |i| ["#{i} hours", i * 60] }, as: :select, hint: "Ignore for camp sessions"
      f.input :camp_session
      f.input :to, :as => :just_datetime_picker, :hint => "End day of Camp"
      f.input :description
    end

    f.actions
  end

  index do
    column :title
    column :image
    column :artist
    column "Registrations", proc {|event| event.registrations.map{|r| r.quantity }.inject(0, :+) }
    column "Seats Remaining", proc { |event| event.remaining_seats }
    column :from
    column :seat_cost
    column :over_21
    column :private_event
    default_actions
  end

  sidebar "Related", only: [:show, :edit] do
    ul do
      li link_to("Registrations", admin_registrations_path(q: { event_id_eq: event.id }))
    end
  end
end