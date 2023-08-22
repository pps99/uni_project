<template>
  <div v-if="nothingtoshow" class="d-flex align-items-center justify-content-center" style="height: 100vh;">
    <button class="btn btn-link" type="button" @click="goback()">Nothing To Show Go Back To Main Page</button>
  </div>
  <div v-else class="accordion" id="accordionExample">
    <div v-for="order in pending_orders_with_details" :key="order.id">
      <div class="card d-flex align-items-center justify-content-center mt-4" style="border: none;">
        <div class="card-header rounded-pill" id="headingOne">
          <h2 class="mb-0">
            <span>
              Order_No: {{ order['order'].id }} <!-- Display actual order number here -->
            </span>
            <span class="ml-3">Option: {{ order['order'].option }}</span>
            <span class="ml-3">Total: {{ order['order'].total }} MMK</span>
            <span>
              <button class="btn btn-link" type="button" data-toggle="collapse" :data-target="'#collapse-' + order['order'].id" aria-expanded="true" :aria-controls="'collapse-' + order['order'].id" @click="openModalWithData(order['order'])">
                Order Detail
              </button>
            </span>
          </h2>
        </div>

        <div :id="'collapse-' + order['order'].id" class="collapse " aria-labelledby="headingOne" data-parent="#accordionExample">
          <div class="card-body" style="width: 28rem;">
            <h5>Customer Name: &nbsp;&nbsp;&nbsp;{{ order['order'].name }}</h5>
            <h5>Phone: &nbsp;&nbsp;&nbsp;{{ order['order'].phone }}</h5>
            <h5>Address: &nbsp;&nbsp;&nbsp;{{ order['order'].address }}</h5>
            <table class="table">
              <thead>
                <tr>
                  <th scope="col" style="text-align: center;">Name</th>
                  <th scope="col" style="text-align: center;">Quantity</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="order_detail in order['order_details']" :key="order_detail.id" class="m-4">
                  <td style="text-align: center;">{{ order_detail.cake_name }}</td>
                  <td style="text-align: center;">{{ order_detail.quantity }}</td>
                </tr>
              </tbody>
            </table>
            <div class="clear-fix">
              <button class="float-right" @click="acceptOrder(order)">Accept Order</button>
              <button class="float-left" @click="cancelOrder(order)">Cancel Order</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      pending_orders_with_details: [],
      nothingtoshow: false,
    }
  },
  methods: {
    fetch_related_items() {
      this.$axios.get(`/orders`)
        .then(response => {
          this.pending_orders_with_details = response.data.pending_orders_with_details;
          if (this.pending_orders_with_details.length === 0) {
            this.nothingtoshow = true;
          }
        })
        .catch(error => {
          this.$notify({
            title: 'Fail',
            text: 'Something went wrong. Please try again',
            type: 'error'
          });
          this.errors = error.response.data.error;
          this.errorMessage = true;
        });
    },
    openModalWithData(dataArray) {
      this.dataArray = dataArray;
      this.showContent = !this.showContent;
    },
    acceptOrder(order) {
      // Your accept order logic here
    },
    cancelOrder(order) {
      // Your cancel order logic here
    },
    goback() {
      this.$router.push('/');
    },
  },
  mounted() {
    this.fetch_related_items();
  },
};
</script>

<style scoped>
</style>
