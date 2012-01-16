class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    puts "bro"
    @tasks = Task.all(:order => "position")
    puts "suuuuppppp  bro"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    @task.position = params[:position]
    render :json => @task.id if @task.save   

    # respond_to do |format|
    #   if @task.save
    #     format.html { redirect_to @task, notice: 'Task was successfully created.' }
    #     format.json { render json: @task, status: :created, location: @task }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @task.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :ok }
    end
  end

  def sort
    params["task_list"].each_with_index do |task, i|
      Task.find(task.split("_")[1]).update_attribute "position", i + 1
    end
    render :nothing => true
  end

  def update_completed
    if params[:completed] == "true"
      Task.find(params[:task_id]).update_attribute "completed_at", Time.now
    else
      puts "bz"
      Task.find(params[:task_id]).update_attribute "completed_at", nil
    end
    render :nothing => true
  end

end
