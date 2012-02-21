class SubscriptionsController < ApplicationController
  # GET /subscriptions
  # GET /subscriptions.xml
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.xml

  def show
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.xml

  def new
    @subscription = Subscription.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscription }
    end
  end

  # GET /subscriptions/1/edit

  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.xml

  def create
    #create a random key to identify the new customer
    customer_id = Array.new(8/2) { rand(256) }.pack('C*').unpack('H*').first

    # The APP_CONFIG value comes from app_config.yml in the Config dir
    @subscription = Subscription.new(params[:subscription])

    #maybe this should be in the model?
    @subscription.plan_id = APP_CONFIG[:subscription_token]
    @subscription.customer_id = customer_id
    @subscription.sub_id = "#{Time.now.strftime("%Y%m%d%H%M%s")}"
    # First try to create the customer in BrainTree's vault, if successful then save the subscription record.
    # I'd like this process improved to so it's using error handling instead of flash messages
    @result = Braintree::Customer.create(
            :id => customer_id,
                    :first_name => params[:subscription]["billing_first_name"],
                    :last_name => params[:subscription]["billing_last_name"],
                    :company => params[:subscription]["billing_company"],
                    :credit_card => {
                            :cardholder_name => params[:subscription]["credit_card_name"],
                            :number => params[:subscription]["credit_card_number"],
                            :token => @subscription.sub_id,
                            :expiration_date => "#{params[:subscription]["credit_card_month"]}/#{params[:subscription]["credit_card_year"]}",
                            :cvv => params[:subscription]["credit_card_cvv_code"],
                            :billing_address => {
                                    :street_address => params[:subscription]["billing_address"],
                                    :extended_address =>params[:subscription]["billing_address2"],
                                    :locality => params[:subscription]["billing_city"],
                                    :region => params[:subscription]["billing_state"],
                                    :postal_code => params[:subscription]["billing_zipcode"],
                                    :country_code_numeric => params[:subscription]["billing_country"]
                            }
                    }
    )
    if @result.success?
      if  create_subscription( @subscription.sub_id, params[:subscription]["fee"])
        @merchant = Merchant.find(session[:merchant_id])
        @merchant.update_attributes(:customer_id => customer_id)
        # I removed all the respond_to code, I don't think I'll be using XML formating, shoudl all the respond_do code be removed?
        if @subscription.save
          redirect_to(:controller => 'subscriptions', :action => 'index', :notice => 'Subscription was successfully created.')
        else
          render :action => "new"
        end
      else
        render :action => "new"
      end
    else
      #was not able to create the customer, display error messages
      render :action => "new"
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.xml

  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to(@subscription, :notice => 'Subscription was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.xml

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to(subscriptions_url) }
      format.xml  { head :ok }
    end
  end

  private
  def create_subscription(sub_id, fee)
    logger.info "User has selected: #{APP_CONFIG[:subscription_token]}"
    result = Braintree::Subscription.create(
            :payment_method_token => sub_id,
                    :id => sub_id,
                    :plan_id => APP_CONFIG[:subscription_token],
                    :trial_duration => 0,
                    :trial_duration_unit => "month",
                    :price => fee
    )
    if result.success?
      return result.subscription.status
    else
      logger.info "ERROR CREATING SUBSCRIPTION: #{result.message}"
      flash[:error] = "We were not able to bill your credit card: #{result.message}"
      return false
    end
  end
end
