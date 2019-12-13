defmodule Parkingappbackend.BillingTest do
  use Parkingappbackend.DataCase, async: true

  alias Parkingappbackend.Billing
  alias Parkingappbackend.Billing.Payment
  alias Parkingappbackend.Auth
  alias Parkingappbackend.Sales

  describe "payments" do
    @valid_attrs %{cardno: "some cardno", nameoncard: "some nameoncard", cvv: 123, expirydate: "some date", amount: 123, user_id: 1, status: "COMPLETED"}
    @valid_attrs_pend %{cardno: "some cardno", nameoncard: "some nameoncard", cvv: 123, expirydate: "some date", amount: 123, user_id: 1, status: "PENDING"}
    @update_attrs %{cardno: "updated cardno", nameoncard: "updated nameoncard", cvv: 1234, expirydate: "updated date"}

    @valid_book_attrs %{start_time: "Some Time", end_time: "some time", status: "Some Status", parking_id: 1, calc_criteria: 1, user_id: 1}

  def booking_fixture(attrs \\ %{}) do
      {:ok, booking} =
        attrs
        |> Enum.into(@valid_book_attrs)
        |> Sales.create_booking()

        booking
  end

  def payment_fixture(attrs \\ %{}) do
    booking = booking_fixture()
    attrs = Map.put(@valid_attrs, :booking_id, booking.id)
    {:ok, payment} =
      attrs
      |> Enum.into(attrs)
      |> Billing.create_payment()

      payment
  end

  def payment_pend_fixture(attrs \\ %{}) do
    booking = booking_fixture()
    attrs = Map.put(@valid_attrs_pend, :booking_id, booking.id)
    {:ok, payment} =
      attrs
      |> Enum.into(attrs)
      |> Billing.create_payment()

      payment
  end


  test "list_payments/1 returns all payment" do
    payment = payment_fixture()
    user = Auth.get_user!(payment.user_id)
    assert hd(Billing.list_payments(user)).id == payment.id
  end

  test "list_completed_payments/1 returns all completed payment" do
    payment = payment_fixture()
    user = Auth.get_user!(payment.user_id)
    assert hd(Billing.list_completed_payments(user)).id == payment.id
  end

  test "list_pending_payments/1 returns all pending payment" do
    payment = payment_pend_fixture()
    user = Auth.get_user!(payment.user_id)
    assert hd(Billing.list_pending_payments(user)).id == payment.id
  end

  test "get_payment!/1 returns the payment with given id" do
    payment = payment_fixture()
    assert Billing.get_payment!(payment.id) == payment
  end

  test "create_payment/1 with valid data creates a payment" do
    booking = booking_fixture()
    attrs = Map.put(@valid_attrs_pend, :booking_id, booking.id)
    assert {:ok, %Payment{} = payment} = Billing.create_payment(attrs)
    assert payment.cardno == "some cardno"
    assert payment.nameoncard == "some nameoncard"
    assert payment.cvv == 123
    assert payment.expirydate == "some date"
    assert payment.amount == 123
    assert payment.booking_id == booking.id
    assert payment.user_id == 1
    assert payment.status == "PENDING"
  end


  test "update_card_det_payment/2 updates the payment" do
    payment = payment_fixture()
    assert {:ok, %Payment{} = payment} = Billing.update_card_det_payment(payment, @update_attrs)
    assert payment.cardno == "updated cardno"
    assert payment.nameoncard == "updated nameoncard"
    assert payment.cvv == 1234
    assert payment.expirydate == "updated date"
  end

  test "update_payment_status/2 updates the payment" do
    payment = payment_fixture()
    assert payment.status == "COMPLETED"
    assert {:ok, %Payment{} = payment} = Billing.update_payment_status(payment, %{status: "PENDING"})
    assert payment.status == "PENDING"
  end

end
end
