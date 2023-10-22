<template>
  <div class="orderview-container">
    <div class="card orderview-card">
      <div class="card-body">
        <h2 class="card-title text-center"> {{ selectedYear }}-{{ months[selectedMonth-1] }} Monthly Sales Report</h2>
        <div class="text-center">
          <button class="btn btn-primary mt-3" @click="back">Back</button>
          <button class="btn btn-success mt-3 ml-2" @click="downloadCSV">Download CSV</button>
        </div>
        <div class="table-responsive mt-3">
          <table class="table table-bordered table-striped">
            <thead>
              <tr>
                <th>Name</th>
                <th>Quantity</th>
                <th>Price</th>
              </tr>
            </thead>
            <tbody v-if="completed_orders_with_details.length > 0">
              <tr v-for="(order, index) in completed_orders_with_details" :key="index">
                <td>{{ order[0] }}</td>
                <td>{{ order[1] }}</td>
                <td>{{ order[2] }}</td>
              </tr>
            </tbody>
            <tbody v-else>
              <tr>
                <td colspan="3" class="text-center">No data available</td>
              </tr>
            </tbody>
            <tfoot>
              <tr>
                <td colspan="2">Total Amount:</td>
                <td>{{ totalAmount }}</td>
              </tr>
            </tfoot>
          </table>
        </div>
        <div v-if="loading" class="text-center mt-3">
          <i class="fa fa-spinner fa-spin"></i> Loading...
        </div>
        <div v-if="error" class="alert alert-danger mt-3">
          Something went wrong. Please try again.
        </div>
      </div>
    </div>
    <div class="month-picker">
      <label for="year">Year:</label>
      <select id="year" v-model="selectedYear" @change="updateDate">
        <option v-for="year in years" :key="year">{{ year }}</option>
      </select>

      <label for="month">Month:</label>
      <select id="month" v-model="selectedMonth" @change="updateDate">
        <option v-for="(month, index) in months" :key="index" :value="index + 1">{{ month }}</option>
      </select>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      completed_orders_with_details: [],
      totalAmount: 0,
      loading: false,
      error: false,
      selectedYear: new Date().getFullYear(),
      selectedMonth: new Date().getMonth() + 1,
      years: [],
      months: [
        'January', 'February', 'March', 'April',
        'May', 'June', 'July', 'August',
        'September', 'October', 'November', 'December'
      ]
    };
  },
  methods: {
    fetch_related_items() {
      this.loading = true; // Show loading indicator
      this.$axios
        .post(`/completed_order?month=${this.selectedMonth}&year=${this.selectedYear}`)
        .then((response) => {
          this.completed_orders_with_details = response.data.combined_result;
          this.calculateTotalAmount();
          this.loading = false; // Hide loading indicator
        })
        .catch((error) => {
          this.error = true; // Show error message
          this.loading = false; // Hide loading indicator
        });
    },
    calculateTotalAmount() {
    this.totalAmount = this.completed_orders_with_details.reduce((total, order) => {
      return total + parseInt(order[2]);
    }, 0);
    },
    downloadCSV() {
        const header = ["Name", "Quantity", "Price"];
        const data = [header, ...this.completed_orders_with_details];

        // Create a CSV string
        const csvContent = data.map((row) => row.join(",")).join("\n");

        // Create a Blob and URL for the CSV data
        const blob = new Blob([csvContent], { type: "text/csv" });
        const url = window.URL.createObjectURL(blob);

        // Create a temporary <a> element to trigger the download
        const a = document.createElement("a");
        a.href = url;
        a.download = `${this.selectedYear}-${this.months[this.selectedMonth-1]} monthly_sales_report.csv`;

        // Trigger the click event on the <a> element to start the download
        a.click();

        // Clean up by revoking the URL
        window.URL.revokeObjectURL(url);
    },
    back() {
      this.$router.back();
    },
    populateYears() {
      const currentYear = new Date().getFullYear();
      for (let year = currentYear - 10; year <= currentYear + 10; year++) {
        this.years.push(year);
      }
    },
    updateDate() {
      // You can perform any additional logic here if needed
      this.fetch_related_items();
    }
  },
  mounted() {
    this.fetch_related_items();
    this.populateYears();
  },
};
</script>

<style scoped>
/* Your existing CSS styles */

/* Additional styles for buttons */
.btn-primary {
  background-color: #007bff;
  color: #fff;
}

.btn-success {
  background-color: #28a745;
  color: #fff;
}

/* Additional styles for table */
th,
td {
  text-align: center;
}

/* Additional styles for Total column */
th:nth-child(4),
td:nth-child(4) {
  font-weight: bold;
}

.month-picker {
  position: absolute;
  top: 30px;
  right: 150px;
}
</style>
