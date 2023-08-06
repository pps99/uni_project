<template>
  <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
    <div class="card w-50 m-auto shadow">
      <div class="card-body">
        <table class="table">
        <thead>
            <tr>
            <th scope="col">Name</th>
            <th scope="col">Quantity</th>
            <th scope="col">Price</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="cart_item in cart_items" :key="cart_item.id">
            <td>{{ cart_item.cake_name }}</td>
            <td>{{ cart_item.quantity }}</td>
            <td>{{ cart_item.unit_price * cart_item.quantity }}</td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right;">Subtotal:</td>
                <td>{{ total }}</td>
            </tr>
            <tr>
                <td class="border-top-0" colspan="2" style="text-align: right;">Tax:</td>
                <td class="border-top-0">{{ tax }}</td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right; font-weight: bold;">Total:</td>
                <td style="font-weight: bold;">{{ total + tax }}</td>
            </tr>
        </tbody>
        </table>
        <button class="float-right mt-2 btn btn-outline-info">Confirm Order</button>
      </div>
    </div>
  </div>
</template>
<script>
export default{
    data() {
        return{
           cart_items: this.$route.params['cartitems'],
           total: 0,
           tax: 0,
        }
    },
    methods: {
      total_price(){
        this.cart_items.map( cart_item => {
          this.total += parseInt(cart_item.unit_price * cart_item.quantity)
        })
        return this.total
      },
      tax_price(){
        const percentage = 5;
        this.tax = (this.total * percentage) / 100;
      }
    },
    mounted() {
      this.total_price(),
      this.tax_price()
    }
}
</script>
