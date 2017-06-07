class HardWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :default, :retry => false

    def perform(*args)
        sleep 10
        print 'Hard worker'
        user = User.first
        print Users::Serializer.new(user)
        print args
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
