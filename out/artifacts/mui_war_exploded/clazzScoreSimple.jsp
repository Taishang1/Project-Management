<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html style="height: 100%">
<head>
    <meta charset="utf-8">
    <script src="js/jquery.js"></script>
    <script src="js/echarts.min.js"></script>
    <script type="text/javascript">
        $(function(){
            $.get('ClazzServlet',{methodName:'getTongJi'},function(data){//
                eval('var arr = ' + data);// [{cname:'一班',count:2},{cname:'二班',count:3}]

                var arr1 = [];//存放班级名字
                var arr2 = [];//存放班级人数

                for(var i = 0; i < arr.length; i++){
                    arr1[i] = arr[i].cname;
                    arr2[i] = arr[i].count;
                }

                var dom = document.getElementById("container");
                var myChart = echarts.init(dom);
                var app = {};

                var option;

                option = {
                    xAxis: {
                        type: 'category',
                        data: arr1
                    },
                    yAxis: {
                        type: 'value'
                    },
                    series: [{
                        data: arr2,
                        type: 'bar'
                    }]
                };

                if (option && typeof option === 'object') {
                    myChart.setOption(option);
                }
            });
        })
    </script>


</head>
<body style="height: 100%; margin: 0">
    <div id="container" style="height: 100%"></div>
</body>
</html>
