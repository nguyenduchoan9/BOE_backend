module Users
    module V1
        class AddVoucher < Operation
            require_authen!

            def process
                if exist
                    {balance: add, status: true}
                else
                    {balance: 0, status: false}
                end
                
            end

            private
            def voucher_code
                params[:code]
            end

            def exist
                Voucher.where('code LIKE ? AND status = true', "#{voucher_code}").count > 0
            end

            def add
                current_balance = user.balance
                update_balance = current_balance + value_code
                begin
                    ActiveRecord::Base.transaction do
                        user.update(balance: update_balance)
                        Voucher.where('code LIKE ? AND status = true', "#{voucher_code}").first.update(status: false)
                    end

                rescue StandardError => error
                    raise ValidateError.new(error)
                end
                update_balance
            end

            def value_code
                Voucher.where('code LIKE ? AND status = true', "#{voucher_code}").first.total
            end
        end
    end
end
