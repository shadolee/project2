class ChargesController < ApplicationController
	def new
  end

	def create
		@booking = Booking.find(params[:id])
	  # Amount in cents
	  @amount = (@booking.product.price * 100).to_i

	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => "Booking id: #{@booking.id}",
	    :currency    => 'usd'
	  )

		@transaction = Transaction.create(amount: @amount,
			user_id: current_user.id, booking_id: @booking.id)


	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to buyer_dashboard_path
	end
end
