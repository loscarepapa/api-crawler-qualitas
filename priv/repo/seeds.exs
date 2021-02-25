alias PolicyApi.Repo
alias PolicyApi.Wallet.Policys

Repo.insert! %Policys{
  name: "Irving Alamo Garcia",
  net_premium: "14,293.87",
  number: "3190748954",
  payment_periodicity: "0",
  status: "1",
  telephone_1: "57009199",
  total_premium: "18,243.27",
  valid_from: "21/03/20",
  valid_until: "21/03/21",
  vehicle: "(I)TR KENWORTH T 800 B 42 STD. MODELO 1997"
}
Repo.insert! %Policys{
  name: "Martin Alejandro Rodriguez Hernandez",
  net_premium: "122,293.87",
  number: "3195743954",
  payment_periodicity: "2",
  status: "0",
  telephone_1: "57009192",
  total_premium: "144,243.27",
  valid_from: "14/05/20",
  valid_until: "14/05/21",
  vehicle: "(I)EQ MBENZ L 1417/52 CHASIS CABINA STD. MAS 7.5 T Y HASTA 14 T MODELO 1991"
}

Repo.insert! %Policys{
  name: "Victor Manuel Flores Santaolalla",
  net_premium: "300,293.87",
  number: "3195743454",
  payment_periodicity: "1",
  status: "1",
  telephone_1: "57009194",
  total_premium: "350,243.27",
  valid_from: "24/01/20",
  valid_until: "24/01/21",
  vehicle: "(I)SEAT CORDOBA 1.6L STELLA AUSTERO STD. MODELO 2002"
}



# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PolicyApi.Repo.insert!(%PolicyApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
