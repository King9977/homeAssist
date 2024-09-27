require 'rails_helper'


RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create(:group, creator: user) }
  let(:task) { create(:task, group: group, user: user) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) { attributes_for(:task) }

      it "creates a new Task" do
        expect {
          post :create, params: { group_id: group.id, task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "assigns the current user to the task" do
        post :create, params: { group_id: group.id, task: valid_attributes }
        expect(Task.last.user).to eq(user)
      end

      it "sets the default status to 'offen'" do
        post :create, params: { group_id: group.id, task: valid_attributes }
        expect(Task.last.status).to eq("offen")
      end

      it "redirects to the tasks index" do
        post :create, params: { group_id: group.id, task: valid_attributes }
        expect(response).to redirect_to(group_tasks_path(group))
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { attributes_for(:task, title: nil) }

      it "does not create a new Task" do
        expect {
          post :create, params: { group_id: group.id, task: invalid_attributes }
        }.to_not change(Task, :count)
      end

      it "renders the new template" do
        post :create, params: { group_id: group.id, task: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { group_id: group.id, id: task.id }
      expect(response).to be_successful
      expect(assigns(:group)).to eq(group)
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_attributes) { { title: "Updated Title" } }

      it "updates the requested task" do
        patch :update, params: { group_id: group.id, id: task.id, task: new_attributes }
        task.reload
        expect(task.title).to eq("Updated Title")
      end

      it "redirects to the tasks index" do
        patch :update, params: { group_id: group.id, id: task.id, task: new_attributes }
        expect(response).to redirect_to(group_tasks_path(group))
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { title: nil } }

      it "does not update the task" do
        patch :update, params: { group_id: group.id, id: task.id, task: invalid_attributes }
        task.reload
        expect(task.title).not_to be_nil
      end

      it "renders the edit template" do
        patch :update, params: { group_id: group.id, id: task.id, task: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is group admin" do
      before do
        allow_any_instance_of(Group).to receive(:admin?).and_return(true)
      end

      it "destroys the requested task" do
        task # create the task
        expect {
          delete :destroy, params: { group_id: group.id, id: task.id }
        }.to change(Task, :count).by(-1)
      end

      it "redirects to the tasks index" do
        delete :destroy, params: { group_id: group.id, id: task.id }
        expect(response).to redirect_to(group_tasks_path(group))
        expect(flash[:notice]).to be_present
      end
    end

    context "when user is not group admin" do
      before do
        allow_any_instance_of(Group).to receive(:admin?).and_return(false)
      end

      it "does not destroy the task" do
        task # create the task
        expect {
          delete :destroy, params: { group_id: group.id, id: task.id }
        }.to_not change(Task, :count)
      end

      it "redirects to the tasks index with an alert" do
        delete :destroy, params: { group_id: group.id, id: task.id }
        expect(response).to redirect_to(group_tasks_path(group))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH #update_status" do
    let(:new_status) { { status: "in_progress", status_comment: "Working on it" } }

    it "updates the status and comment of the task" do
      patch :update_status, params: { group_id: group.id, id: task.id, task: new_status }
      task.reload
      expect(task.status).to eq("in_progress")
      expect(task.status_comment).to eq("Working on it")
    end

    it "redirects to the tasks index" do
      patch :update_status, params: { group_id: group.id, id: task.id, task: new_status }
      expect(response).to redirect_to(group_tasks_path(group))
      expect(flash[:notice]).to be_present
    end
  end

  describe "GET #edit_status" do
    it "returns a success response" do
      get :edit_status, params: { group_id: group.id, id: task.id }
      expect(response).to be_successful
      expect(assigns(:group)).to eq(group)
      expect(assigns(:task)).to eq(task)
    end
  end
end