var trs = [...document.querySelectorAll("tr")].slice(2);
trs.forEach((el)=>{
    var tds               =  [...el.querySelectorAll("td")]
    var country           =  tds[2];
    var agency            =  tds[3];
    var date_of_decision  =  tds[4];
    var fine_amount_euro  =  tds[5];
    var controller_processor  =  tds[6];
    var sector  =  tds[7];
    var quoted_articles  =  tds[8];
    var type  =  tds[9];
    var summary  =  tds[10];
    console.log(tds)
    console.log(tds[11])
    var links  =  tds[11].querySelectorAll("a") ? [...tds[11].querySelectorAll("a")].map(el => el.href) : []
    instance_data  = {
        "country": country.textContent,
        "agency": agency.textContent,
        "date_of_decision": date_of_decision.textContent,
        "fine_amount_euro": fine_amount_euro.textContent,
        "controller_processor": controller_processor.textContent,
        "sector": sector.textContent,
        "quoted_articles": quoted_articles.textContent,
        "type": type.textContent,
        "summary": summary.textContent,
        "links": links,
    }
    data.push(instance_data)
    console.log(instance_data)
})
