<template>
  <div class="d-flex align-items-center justify-content-center orderview-container" style="height: 100vh;">
    <div class="card orderview-card shadow">
      <div class="card-body" style="text-decoration-color: white;">
        <table class="table">
          <thead>
            <tr>
              <th scope="col" style="text-align: center;">Name</th>
              <th scope="col" style="text-align: center;">Quantity</th>
              <th scope="col" style="text-align: center; width: 150px;">Price</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="cart_item in cart_items" :key="cart_item.id">
              <td style="text-align: center;">{{ cart_item.cake_name }}</td>
              <td style="text-align: center;">
                <button @click="decrement(cart_item)" class="btn btn-link px-2 mr-2">
                  <b-icon icon="dash" aria-hidden="true"></b-icon>
                </button>
                {{ cart_item.quantity }}
                <button @click="increment(cart_item)" class="btn btn-link px-2 ml-2">
                  <b-icon icon="plus" aria-hidden="true"></b-icon>
                </button>
              </td>
              <td style="text-align: center;">{{ cart_item.unit_price * cart_item.quantity }}</td>
            </tr>
            <tr>
              <td colspan="2" style="text-align: right;">Subtotal:</td>
              <td style="text-align: center;">{{ total }}</td>
            </tr>
            <tr v-if="selectedOption == 'delivery'">
              <td class="border-top-0" colspan="2" style="text-align: right;">Deli:</td>
              <td class="border-top-0" style="text-align: center;">{{ deli_price }}</td>
            </tr>
            <tr>
              <td class="border-top-0" colspan="2" style="text-align: right;">Tax:</td>
              <td class="border-top-0" style="text-align: center;">{{ tax }}</td>
            </tr>
            <tr>
              <td colspan="2" style="text-align: right; font-weight: bold;">Total:</td>
              <td class="font-bold" style="text-align: center;">{{ total + tax + deli_price }}</td>
            </tr>
          </tbody>
        </table>
        <div class="d-flex align-items-center justify-content-center" >
          <label class="mr-2" style="color: white;">
            <input type="radio" v-model="selectedOption" value="delivery" @change="delivery_price">
            Cash On Delivery
          </label>
          <label style="color: white;">
            <input type="radio" v-model="selectedOption" value="pick_up" @change="delivery_price">
            Pick Up
          </label>
        </div>
        <div class="clear-fix">
          <button class="float-left mt-2 btn btn-dark" @click="back">Back</button>
          <button class="float-right mt-2 btn btn-confirm"
                  @click="save_order"
                  :disabled="isConfirmButtonDisabled"
                  :class="{ 'disabled': isConfirmButtonDisabled }">
            Confirm Order
          </button>
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
           selectedOption: '',
           amount: 0,
           deli_price: 0
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
      delivery_price() {
        console.log(this.selectedOption,"sel")
        this.deli_price = this.selectedOption === 'delivery' ? 2000 : 0;
      },
      save_order(){
        if( this.amount >= this.total)
        {
          const postData = {
            cart_items: this.cart_items,
            selectedOption: this.selectedOption,
            total_price: this.total+this.tax+this.deli_price
          };
          this.$axios.post(`/orders`, postData)
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
        }else
        {
          alert("Your balance is insufficient! Plase Top Up");
        }
      },
      back(){
        this.$router.back();
      },
      increment(cart_item){
        cart_item.quantity ++;
        this.updateLocalStorage();
        this.total_price(),
        this.tax_price()
      },
      decrement(cart_item){
        if (cart_item.quantity != 1){
        cart_item.quantity --;
        this.updateLocalStorage();
        this.total_price(),
        this.tax_price()
        }
      },
      updateLocalStorage() {
        localStorage.setItem('cart_items', JSON.stringify(this.cart_items));
      },
    },
    mounted() {
      this.cart_items = JSON.parse(localStorage.getItem('cart_items')) || [];
      this.amount = this.$route.params['amount']
      this.total_price(),
      this.tax_price(),
      this.delivery_price
    },
    computed: {
      isConfirmButtonDisabled() {
        return !this.selectedOption; // Returns true if no radio option is selected
      }
    }
}
</script>
<style scoped>

  .orderview-container {
    background-image: url('~/assets/backery_index_img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
  }

  .orderview-card {
    width: 700px;
    background-color: rgba(255, 255, 255, 0.5);
    border-radius: 25px;
  }

  th, td {
    text-align: center;
    color: white;
  }
  .font-bold {
    font-weight: bold;
  }
  .clear-fix::after {
    content: "";
    display: table;
    clear: both;
  }

  .btn-link,.btn-link:hover{
  color: white;
  }
  .btn-confirm{
    border: 1px solid white;
    color: white;
  }
</style>