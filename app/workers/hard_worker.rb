class HardWorker
    include Sidekiq::Worker
    include ApplicationHelper
    sidekiq_options :queue => :default, :retry => false

    def perform(*args)
        # user = User.find_by(:username => 'hoangnguyen')
        # send_message user.reg_token

        # user = User.find_by(:username => 'masterchef')
        # send_message_to_chef('body', user.reg_token)

        user = User.find_by(:username => 'masterwaiter')
        send_message_to_waiter 'body', user.reg_token
        # sleep 10
        # print 'Hard worker'
        # user = User.first
        # print Users::Serializer.new(user)
        # print args
        # level = args[:level]
        # case level
        # when "super_hard"
        #     sleep 20
        #     print "super_hard"
        # when "easy"
        #     sleep 10
        #     print "easyaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        # else
        #     sleep 1
        #     print "Nothing"

        # end
    end
end
