import org.objectweb.asm.Type;

import java.sql.*;
import java.time.LocalDate;

public class main {

    private static String dbPassword="";
    private static String dbUserName="root";
    private static String dburl="jdbc:mysql://localhost:3306/lobotickets";

    public static void main(String[] argus) throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
       try( Connection connection= DriverManager.getConnection(dburl,dbUserName,dbPassword);) {
           simpleReadWithExecuteQuery(connection);
           simpleInsertWithExecuteQuery(connection);
           simpleUpdateWithExceuteQuery(connection);
           simpleDeleteWithExcuteQuery(connection);
           simpleInsertWithPramaExcuteQuery(connection);
           simpleCountWithExcuteQuery(connection);
           simpleQueryWithGetByObject(connection);
           insertNullValue(connection,"mohammed",null);
           SimpleCallableStmtWithSP(connection);
           SimpleCallableStmtWithSPInPrama(connection);
           SimpleCallableStmtWithSPOutPrama(connection);
           SimpleCallableStmtWithSPInOutPrama(connection);
       }
    }
    private static void SimpleCallableStmtWithSPInOutPrama(Connection connection) throws SQLException {
        var sql = "{call SetNewPrice(?,?,?)}";
        try(CallableStatement cs = connection.prepareCall(sql)){
            cs.setInt(1,1);
            cs.setDouble(2,0.1);
            cs.setDouble(3,12);
            cs.registerOutParameter(3,Types.DECIMAL);
            var res = cs.execute();
            System.out.println("NEw Price" + cs.getDouble(3));
        }
    }
    private static void SimpleCallableStmtWithSPOutPrama(Connection connection) throws SQLException {
        var sql = "{call GetTotalSales(?)}";
        try(CallableStatement cs = connection.prepareCall(sql)){
            cs.registerOutParameter(1,Types.DECIMAL);
            var res = cs.execute();
            System.out.println("Totle Sales" + cs.getDouble(1));
        }
    }
    private static void SimpleCallableStmtWithSPInPrama(Connection connection) throws SQLException {
        var sql = "{call GigReport(?,?)}";
        try(CallableStatement cs = connection.prepareCall(sql)){
            cs.setDate("startdate",Date.valueOf(LocalDate.of(2022,11,1)));
            cs.setDate("enddate",Date.valueOf(LocalDate.of(2022,11,7)));
            var res = cs.executeQuery();
            while (res.next()){
                Date date = res.getDate("date");
                String act = res.getString("act");
                System.out.println(date + " - " + act);
            }
        }
    }
    private static void SimpleCallableStmtWithSP(Connection connection) throws SQLException {
        var sql = "{call GetActs()}";
        try(CallableStatement cs = connection.prepareCall(sql)){
            var res = cs.executeQuery();
            while (res.next()){
                String name = res.getString("name");
                String recordLabel = res.getString("recordLabel");
                System.out.println(name + " - " + recordLabel);
            }
        }
    }

    private static void insertNullValue(Connection conn, String name,String recordLabel) throws SQLException {
        var sql = "insert into Acts(name,recordLabel) values(?,?)";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1,name);
            if(recordLabel !=null){
                ps.setString(2,recordLabel);
            }else{
                ps.setNull(2, Type.CHAR);
            }
          int res=   ps.executeUpdate();
            if (res>0) System.out.println("insert with set null works");
        }
}
    private static void simpleQueryWithGetByObject(Connection connection) throws SQLException {
        String sql= "select name,capacity from venues where name like ?";
        var stmt= connection.prepareStatement(sql);
        stmt.setString(1,"%the%");
        var res = stmt.executeQuery();
        String name="";
        int capacity=0;
        if(res.next()){
           Object nameValue= res.getObject("name");
           Object capacityValue= res.getObject("capacity");
           if(nameValue instanceof String) name= (String)nameValue;
           if(capacityValue instanceof Integer) capacity=(int)capacityValue;
            System.out.println(name + " has capacity of "+ capacity);

        }
    }

    private static void simpleCountWithExcuteQuery(Connection connection) throws SQLException {
        String sql= "select count(*) as count from venues";
        var stmt= connection.prepareStatement(sql);
        var res = stmt.executeQuery();
        if(res.next()){
            var numberOfVenues= res.getInt(1);
            var numberOfVenues1= res.getInt("count");
            System.out.println("number of venues " + numberOfVenues);

        }
    }

    private static void simpleInsertWithPramaExcuteQuery(Connection connection) throws SQLException {
        String sql = "insert into venues(name,capacity) values(?,?)";
        var stmt= connection.prepareStatement(sql);
        stmt.setString(1,"mohammed");
        stmt.setInt(2,200);
        int res = stmt.executeUpdate();
        if(res>0) System.out.println("update by pramas example 1");
    }

    private static void simpleDeleteWithExcuteQuery(Connection connection) throws SQLException {
        String sql = "delete from venues where name='Ali'";
        var stmt= connection.prepareStatement(sql);
        int result = stmt.executeUpdate();
        if(result>0) System.out.println("update 3 the database");
    }

    private static void simpleUpdateWithExceuteQuery(Connection connection) throws SQLException {
        String sql = "update venues set capacity=30 where name='Ali'";
        var stmt= connection.prepareStatement(sql);
        int result = stmt.executeUpdate();
        if(result>0) System.out.println("update 2 the database");
    }

    private static void simpleInsertWithExecuteQuery(Connection connection) throws SQLException {
        String sql = "insert into venues (name,capacity) values('Ali',20)";
        var stmt= connection.prepareStatement(sql);
        int result = stmt.executeUpdate();
        if(result>0) System.out.println("update the database");
    }

    private static void simpleReadWithExecuteQuery(Connection connection) throws SQLException {
        String sql = "select name, capacity from venues";
        var stmt= connection.prepareStatement(sql);
        var result=stmt.executeQuery();
        while (result.next()){
            System.out.print(".");
        }
        System.out.println();
    }
}
