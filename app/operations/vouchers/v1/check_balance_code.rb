module Vouchers
    module V1
        class CheckBalanceCode < Operation

            def process
                {status: exist}
            end

            private
            def voucher_code
                params[:code]
            end

            def exist
                Voucher.where('code LIKE ? AND status = true', "#{voucher_code}").count > 0
            end
        end
    end
end
