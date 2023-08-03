<template>
<div class="dropdown ml-2">
  <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
    <b-icon icon="cart-plus-fill" aria-hidden="true"></b-icon> Cart
  </button>
  <div class="dropdown-menu  p-4 " style="max-width: 200px;">
    <a class="dropdown-item clear-fix" v-for="cart_item in cart_items" :key="cart_item.id">
      <div class="float-left">
        <span>
          {{ cart_item.quantity }}
        </span>
        <span>
          {{ cart_item.cake_name }}
        </span>
        <span>
          {{ cart_item.total }}
        </span>
      </div>
      <div class="float-right">
        <b-icon icon="trash" aria-hidden="true"></b-icon>
      </div>
      <div role="separator" class="dropdown-divider"></div>
    </a>
    
  </div>
</div>
</template>

<script>
export default {
  data(){
    return {
      cart_items: []
    }
  },
  methods: {
    get_all_card_items(){
      console.log("HELLO")
      this.$axios.get(`/cart_items/all`)
        .then(response => {
          console.log(response)
          this.cart_items = response.data.cart_items
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
    }
  },

  mounted() {
    this.get_all_card_items()
  }
  
};
</script>