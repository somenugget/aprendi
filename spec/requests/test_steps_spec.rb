require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/test_steps", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # TestStep. As you add validations to TestStep, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      TestStep.create! valid_attributes
      get test_steps_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      test_step = TestStep.create! valid_attributes
      get test_step_url(test_step)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_test_step_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      test_step = TestStep.create! valid_attributes
      get edit_test_step_url(test_step)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new TestStep" do
        expect {
          post test_steps_url, params: { test_step: valid_attributes }
        }.to change(TestStep, :count).by(1)
      end

      it "redirects to the created test_step" do
        post test_steps_url, params: { test_step: valid_attributes }
        expect(response).to redirect_to(test_step_url(TestStep.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new TestStep" do
        expect {
          post test_steps_url, params: { test_step: invalid_attributes }
        }.to change(TestStep, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post test_steps_url, params: { test_step: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested test_step" do
        test_step = TestStep.create! valid_attributes
        patch test_step_url(test_step), params: { test_step: new_attributes }
        test_step.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the test_step" do
        test_step = TestStep.create! valid_attributes
        patch test_step_url(test_step), params: { test_step: new_attributes }
        test_step.reload
        expect(response).to redirect_to(test_step_url(test_step))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        test_step = TestStep.create! valid_attributes
        patch test_step_url(test_step), params: { test_step: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested test_step" do
      test_step = TestStep.create! valid_attributes
      expect {
        delete test_step_url(test_step)
      }.to change(TestStep, :count).by(-1)
    end

    it "redirects to the test_steps list" do
      test_step = TestStep.create! valid_attributes
      delete test_step_url(test_step)
      expect(response).to redirect_to(test_steps_url)
    end
  end
end
