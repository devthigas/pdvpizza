class DiningTablesController < ApplicationController
  before_action :set_dining_table, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_gerente, only: [:new, :create, :edit, :update, :destroy]

  def index
    @dining_tables = DiningTable.all.order(:number)
  end

  def show
  end

  def new
    @dining_table = DiningTable.new
  end

  def edit
  end

  def create
    @dining_table = DiningTable.new(dining_table_params)

    respond_to do |format|
      if @dining_table.save
        format.html { redirect_to dining_tables_path, notice: "Mesa criada com sucesso!" }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @dining_table.update(dining_table_params)
        format.html { redirect_to dining_tables_path, notice: "Mesa atualizada com sucesso!" }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @dining_table.destroy
      respond_to do |format|
        format.html { redirect_to dining_tables_path, notice: "Mesa excluída com sucesso!" }
        format.turbo_stream
      end
    else
      redirect_to dining_tables_path, alert: @dining_table.errors.full_messages.to_sentence
    end
  end

  private

  def set_dining_table
    @dining_table = DiningTable.find(params[:id])
  end

  def dining_table_params
    params.expect(dining_table: [:number, :seats, :status])
  end

  def require_admin_or_gerente
    unless Current.session.user.admin? || Current.session.user.gerente?
      redirect_to root_path, alert: "Você não tem permissão para realizar esta ação."
    end
  end
end
