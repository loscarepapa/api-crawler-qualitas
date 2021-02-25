defmodule PolicyApiWeb.PolicysView do
  use PolicyApiWeb, :view
  alias PolicyApiWeb.PolicysView

  def render("index.json", %{policy: policy}) do
    %{data: render_many(policy, PolicysView, "policys.json")}
  end

  def render("show.json", %{policys: policys}) do
    %{data: render_one(policys, PolicysView, "policys.json")}
  end

  def render("policys.json", %{policys: policys}) do
    %{id: policys.id,
      number: policys.number,
      vehicle: policys.vehicle,
      name: policys.name,
      net_premium: policys.net_premium,
      total_premium: policys.total_premium,
      valid_from: policys.valid_from,
      valid_until: policys.valid_until,
      payment_periodicity: policys.payment_periodicity,
      status: policys.status,
      telephone_1: policys.telephone_1}
  end
end
