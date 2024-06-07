<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.json.JSONObject" %>

<%
    //•
    String DRIVER_CLASS_NAME = "org.mariadb.jdbc.Driver";
    String URL = "jdbc:mariadb://localhost:3306/vgc";
    String USERNAME = "root";
    String PASSWORD = "1234";
    
   //™”
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
  
    JSONObject lastReservation = new JSONObject();

    try {
        
        Class.forName(DRIVER_CLASS_NAME);
        con = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        
      
        String sql = "SELECT reservationId, location, hall, spot, date, starttime, endtime FROM reservation ORDER BY reservationId DESC LIMIT 1";
        
    
        stmt = con.prepareStatement(sql);
        
      
        rs = stmt.executeQuery();
        
        if (rs.next()) {								
            lastReservation.put("reservationId", rs.getInt("reservationId"));
            lastReservation.put("location", rs.getString("location"));
            lastReservation.put("hall", rs.getString("hall"));
            lastReservation.put("spot", rs.getString("spot"));
            lastReservation.put("date", rs.getString("date"));
            lastReservation.put("starttime", rs.getString("starttime"));
            lastReservation.put("endtime", rs.getString("endtime"));
        }
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {// œ
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    //
    response.setContentType("application/json"); //‹œ
    response.setHeader("Access-Control-Allow-Origin", "*"); 
    out.print(lastReservation.toString());
%>