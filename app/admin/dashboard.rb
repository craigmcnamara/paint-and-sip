ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    columns do
      column do
        panel "Upcoming Events Posts" do
          ul do
            Event.upcoming.limit(5).map do |event|
              li link_to(event.title, admin_event_path(event))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "The local time is #{Time.zone.now}."
        end
      end
    end
  end
end
