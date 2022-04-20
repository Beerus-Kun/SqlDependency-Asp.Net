// Please see documentation at https://docs.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.

$(()=>{
    let connection = new signalR.HubConnectionBuilder().withUrl("/signalServer").build()
    connection.start()
    connection.on("refreshBaocaos", function(){
        loadData();
    })

    loadData();

    function loadData(){
        var tr = ''
        var mauTran = '<td style = "color:rgb(255, 65, 182);">'
        var mauSan = '<td style = "color:rgb(68, 224, 246);">'
        var mauTc = '<td style = "color:rgb(243, 239, 39);">'
        var mauXau = '<td style = "color:rgb(225, 68, 65);">'
        var mauTot = '<td style = "color:rgb(53, 185, 71);">'
        var end = '</td>'
        $.ajax({
            url: '/Home/GetBaocaos',
            method: 'GET',
            success: (result)=>{
                $.each(result,(k, v)=>{
                    tr = tr + 
                    `<tr>
                        <td>${v.macp}</td>`
                    if (v.tc < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + mauTc + `${v.tc}` + end
                    }

                    if (v.tran < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + mauTran + `${v.tran}` + end
                    }

                    if (v.san < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + mauSan + `${v.san}` + end
                    }

                    if (v.giamua1 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.giamua1 >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.giamua1 > v.tc) {
                            tr = tr + mauTot
                        } else if (v.giamua1 == v.tc) {
                            tr = tr + mauTc 
                        } else if (v.giamua1 > v.san) {
                            tr = tr + mauXau 
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.giamua1}` + end
                    }

                    if (v.giamua2 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.giamua2 >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.giamua2 > v.tc) {
                            tr = tr + mauTot
                        } else if (v.giamua2 == v.tc) {
                            tr = tr + mauTc
                        } else if (v.giamua2 > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.giamua2}` + end
                    }

                    if (v.giamua3 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.giamua3 >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.giamua3 > v.tc) {
                            tr = tr + mauTot
                        } else if (v.giamua3 == v.tc) {
                            tr = tr + mauTc
                        } else if (v.giamua3 > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.giamua3}` + end
                    }

                    if (v.klmua1 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.klmua1}</td>`
                    }

                    if (v.klmua2 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.klmua2}</td>`
                    }

                    if (v.klmua3 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.klmua3}</td>`
                    }

                    if (v.giakhoplenh < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.giakhoplenh >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.giakhoplenh > v.tc) {
                            tr = tr + mauTot
                        } else if (v.giakhoplenh == v.tc) {
                            tr = tr + mauTc
                        } else if (v.giakhoplenh > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.giakhoplenh}` + end
                    }

                    if (v.klkhoplenh < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.klkhoplenh}</td>`
                    }

                    if (v.giaban1 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.giaban1 >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.giaban1 > v.tc) {
                            tr = tr + mauTot
                        } else if (v.giaban1 == v.tc) {
                            tr = tr + mauTc
                        } else if (v.giaban1 > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.giaban1}` + end
                    }

                    if (v.giaban2 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.giaban2 >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.giaban2 > v.tc) {
                            tr = tr + mauTot
                        } else if (v.giaban2 == v.tc) {
                            tr = tr + mauTc
                        } else if (v.giaban2 > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.giaban2}` + end
                    }

                    if (v.giaban3 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.giaban3 >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.giaban3 > v.tc) {
                            tr = tr + mauTot
                        } else if (v.giaban3 == v.tc) {
                            tr = tr + mauTc
                        } else if (v.giaban3 > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.giaban3}` + end
                    }

                    if (v.klban1 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.klban1}</td>`
                    }

                    if (v.klban2 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.klban2}</td>`
                    }

                    if (v.klban3 < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.klban3}</td>`
                    }

                    if (v.tongkl < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.tongkl}</td>`
                    }

                    if (v.dumua < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.dumua}</td>`
                    }

                    if (v.duban < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        tr = tr + `<td>${v.duban}</td>`
                    }

                    if (v.tb < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.tb >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.tb > v.tc) {
                            tr = tr + mauTot
                        } else if (v.tb == v.tc) {
                            tr = tr + mauTc
                        } else if (v.tb > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.tb}` + end
                    }

                    if (v.cao < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.cao >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.cao > v.tc) {
                            tr = tr + mauTot
                        } else if (v.cao == v.tc) {
                            tr = tr + mauTc
                        } else if (v.cao > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.cao}` + end
                    }

                    if (v.thap < 0) {
                        tr = tr + `<td></td>`
                    } else {
                        if (v.thap >= v.tran) {
                            tr = tr + mauTran
                        } else if (v.thap > v.tc) {
                            tr = tr + mauTot
                        } else if (v.thap == v.tc) {
                            tr = tr + mauTc
                        } else if (v.thap > v.san) {
                            tr = tr + mauXau
                        } else {
                            tr = tr + mauSan
                        }
                        tr = tr + `${v.thap}` + end
                    }

                    tr = tr + `</tr>`
                })

                $('#tableBody').html(tr)
            },
            error: (err)=>{
                console.log(err)
            }
        })
    }
})