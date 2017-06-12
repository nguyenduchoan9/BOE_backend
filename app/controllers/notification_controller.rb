class NotificationController < ApplicationController
    include ApplicationHelper

    def index
        reg_tokens = 'eHIfxZKU0d0:APA91bF18-W5mekn-2Rm08PBLPmM2p9gPKMctvTkAzL1oubxmMgLk8H1IaKnMBBu0cmAutbypIyQmxOjyj84M2AmF1ZNgGjgzbouSIkOD-GovbxR5CYh7t3fcRkQme7IIwT0QJcrS00k'
        a = send_message("title", "body", reg_tokens)
        message = "success"
        message
        a.to_s
    end

    def notification_chef
    end

    def notification_waiter
    end

    def notification_diner
    end

    def create
        redirect_to notifications_path
    end

    def background_job
        HardWorker.perform_async("easy")
        ""
    end

    def register_reg_token
    end
end
