# frozen_string_literal: true

class BonusActivationJob
  def initialize(user, index)
    @user = user
    @index = index
  end

  def run
    if @index < 11
      if @user.commission && @user.activated?
        commission = (@user.commission.value || 0) + 4
        commission = 0 if commission.negative?
        @user.commission.update(value: commission)
      end

      if @user.host
        command = BonusActivationJob.new(@user.host, @index + 1)
        command.run
      end
    end
  end
end
