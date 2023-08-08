<template>
  <div>
    <div class="d-flex container align-items-center justify-content-center" style="height: 100vh;">
      <div class="accordion" role="tablist">
        <div v-for="groupeditem in groupeditems" :key="groupeditem.id" class="mb-3">
          <b-card no-body class="mb-1">
          <b-card-header header-tag="header" class="p-1" role="tab">
            <span> <a> Order No => {{ groupeditem[0].id }} </a> </span>
            <span> <a> Status => {{ groupeditem[0].status }} </a> </span>
            <span>
                <b-button block v-b-toggle.accordion-{{ groupeditem[0].id }} variant="info">Accordion 1</b-button>
                </span>
              </b-card-header>
              <b-collapse :id="accordion-`${groupeditem[0].id}`" visible accordion="my-accordion" role="tabpanel">
                <b-card-body>
                  <b-card-text>I start opened because <code>visible</code> is <code>true</code></b-card-text>
                  <b-card-text>{{ text }}</b-card-text>
                </b-card-body>
              </b-collapse>
            </b-card>
          <div v-if="showContent" class="row">
              <div class="col">
                <div class="collapse multi-collapse" :id="`multiCollapseExample${groupeditem[0].id}`">
                  <div class="card card-body">
                    <table class="table">
                      <thead>
                      <tr>
                        <th scope="col" style="text-align: center;">Name</th>
                        <th scope="col" style="text-align: center;">Quantity</th>
                        <th scope="col" style="text-align: center;">Price</th>
                      </tr>
                      </thead>
                        <tbody v-for="relateditems in dataArray" :key="relateditems.id" class="m-4">
                          <tr>
                          <td style="text-align: center;">{{ relateditems.cake_name }}</td>
                          <td style="text-align: center;">{{ relateditems.quantity }}</td>
                          <td style="text-align: center;">{{ relateditems.total }}   </td> 
                          </tr>
                        </tbody>
                    </table>
                      <div class="clear-fix">
                        <button class="float-right">Accept Order</button>
                        <button class="float-left">Cancel Order</button>
                      </div>
                      </div>
                </div>
              </div>
           </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default{
  data() {
    return {
      groupeditems: [],
      dataArray: [],
      showContent: false
    }
  },
  methods: {
    fetch_related_items() {
      this.$axios.get(`/user_details`)
        .then(response => {
          this.$router.push('#')
          this.groupeditems = response.data.grouped_user_details
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
    openModalWithData(dataArray) {
      this.dataArray = dataArray
      this.showContent = !this.showContent
    }
        
  },
  mounted() {
    this.fetch_related_items()
  }
}

</script>
<style scoped>
</style>