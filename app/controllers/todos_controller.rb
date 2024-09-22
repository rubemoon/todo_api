class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: [ :show, :update, :destroy ]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  # GET /todos
  def index
    @todos = policy_scope(Todo)
    render json: @todos
  end

  # GET /todos/:id
  def show
    authorize @todo
    render json: @todo
  end

  # POST /todos
  def create
    @todo = current_user.todos.build(todo_params)
    authorize @todo
    if @todo.save
      render json: @todo, status: :created
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/:id
  def update
    authorize @todo
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /todos/:id
  def destroy
    authorize @todo
    @todo.destroy
    head :no_content
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Todo not found" }, status: :not_found
  end

  def todo_params
    params.require(:todo).permit(:title, :completed)
  end
end
