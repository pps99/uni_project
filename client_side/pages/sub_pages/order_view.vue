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
            <td>{{ cart_item.total }}</td>
            </tr>
        </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
<script>
export default{
    data() {
        return{
           cart_items: this.$route.params['cartitems'],
           number: '0'
        }
    },
    methods: {

    },
}
</script>