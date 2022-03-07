const API_KEY = "PRIVATE";

// target HTML elements
// . is for class
// # is for id
const button = document.querySelector(".chart-button");
const input = document.querySelector(".ticker-input");
const tickerInfoColumn = document.querySelector("#ticker-components-col");
const template = document.querySelector(".info-template");

// gets the chart data using the API
async function getChart(ticker) {
    const url = "https://yfapi.net/v8/finance/chart/" + ticker;

    const options = {
        method: "GET",
        withCredentials: true,
        headers: {
            "x-api-key": API_KEY,
            "Content-type": "application/json"
        }
    };

    // response we get when we call on the URL
    const response = await fetch(url, options);
    const data = await response.json();

    return data.chart.result[0].meta;
}

// handle the button click
async function handleButton() {
    const ticker = input.value.trim(); // trim removes whitespaces from the beginning and the end

    // return nothing if no input is given
    // 1 == "1" true
    // 1 === "1" false
    if (ticker === "") return;

    // Get data
    const result = await getChart(ticker);

    const symbol = result.symbol;
    const currency = result.currency;
    const chartPreviousClose = result.chartPreviousClose;

    // CLone the template
    let newTickerInfo = template.content.cloneNode(true);

    // Assign values to template fields
    newTickerInfo.querySelector(".symbol").textContent = symbol;
    newTickerInfo.querySelector(".currency").textContent = currency;
    newTickerInfo.querySelector(".chartPreviousClose").textContent = chartPreviousClose;

    // Append the template onto column
    tickerInfoColumn.appendChild(newTickerInfo);
}

// create an event listener for the button
button.addEventListener("click", handleButton);
