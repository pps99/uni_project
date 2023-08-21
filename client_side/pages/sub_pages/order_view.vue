<template>
  <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
    <div class="card w-50 m-auto shadow">
      <div class="card-body">
        <table class="table">
        <thead>
            <tr>
            <th scope="col" style="text-align: center;">Name</th>
            <th scope="col" style="text-align: center;">Quantity</th>
            <th scope="col" style="text-align: center;">Price</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="cart_item in cart_items" :key="cart_item.id">
            <td style="text-align: center;">{{ cart_item.cake_name }}</td>
            <td style="text-align: center;" >
              <button @click="decrement(cart_item)" class="px-2 mr-2" style=" background-color: transparent !important; border: none; ">
                  <b-icon icon="dash" aria-hidden="true"></b-icon> 
              </button> 
              {{ cart_item.quantity }}
              <button @click="increment(cart_item)" class="px-2 ml-2" style=" background-color: transparent !important; border: none; ">
                  <b-icon icon="plus" aria-hidden="true"></b-icon> 
              </button> 
            </td>
            <td style="text-align: center;">{{ cart_item.unit_price * cart_item.quantity }}</td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right;">Subtotal:</td>
                <td style="text-align: center;">{{ total }}</td>
            </tr>
            <tr>
                <td class="border-top-0" colspan="2" style="text-align: right;">Tax:</td>
                <td class="border-top-0" style="text-align: center;">{{ tax }}</td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right; font-weight: bold;">Total:</td>
                <td style="font-weight: bold; text-align: center;">{{ total + tax }}</td>
            </tr>
        </tbody>
        </table>
        <label>
            <input type="radio" v-model="selectedOption" value="cash_on_deli"> Cash On Delivery
        </label>
        <label>
            <input type="radio" v-model="selectedOption" value="pick_up"> Pick Up
        </label>
        <div class="clear-fix">
          <button class="float-left mt-2 btn btn-outline-dark" @click="back">Back</button>
          <button class="float-right mt-2 btn btn-outline-info" @click="save_order">Confirm Order</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default{
    data() {
        return{
           cart_items: [],
           total: 0,
           tax: 0,
           selectedOption: ''
        }
    },
    methods: {
      total_price(){
        this.total = 0
        this.cart_items.map( cart_item => {
          this.total += parseInt(cart_item.unit_price * cart_item.quantity)
        })
        return this.total
      },
      tax_price(){
        const percentage = 5;
        this.tax = (this.total * percentage) / 100;
      },
      save_order(){
        this.cart_items.map(cart_item =>{
          cart_item['option'] = this.selectedOption
        })
        this.$axios.post(`/user_details`,this.cart_items)
        .then(response => {
          alert("Your Order Have Saved Successfully")
          localStorage.clear();
          this.$router.push('/')
          
        })
        .catch(error => {
          this.$notify({
            title: 'Fail',
            text: 'Something went wrong. Please try again',
            type: 'error'
          });
          this.errors = error.response.data.error
          this.errorMessage = true
        })
      },
      back(){
        this.$router.back();
      }
    },
    mounted() {
      this.cart_items = this.$route.params['cartitems']
      this.total_price(),
      this.tax_price()
    }
}
</script>
