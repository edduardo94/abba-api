# frozen_string_literal: true

class BonusReferralJob
  def initialize(user, user_type, index)
    @user = user
    @index = index
    @user_type = user_type
  end

  def run
    if @index < 6
      if @user.commission && @user.activated?
        commission = (@user.commission.value || 0) + amount(@user_type, @index)
        commission = 0 if commission.negative?
        @user.commission.update(value: commission)
      end

      if @user.host
        command = BonusReferralJob.new(@user.host, @user_type, @index + 1)
        command.run
      end
    end
  end

  private

  def amount(user_type, index)
    if user_type == 2
      type_two(index)
    elsif user_type == 3
      type_three(index)
    elsif user_type == 4
      type_four(index)
    end
  end

  def type_two(index)
    case index
    when 1
      40
    else
      2.5
    end
  end

  def type_three(index)
    case index
    when 1
      80
    else
      5
    end
  end

  def type_four(index)
    case index
    when 1
      160
    else
      10
    end
  end
end
