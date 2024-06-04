<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%
response.setHeader("Access-Control-Allow-Origin","*");

String DRIVER_CLASS_NAME = "org.mariadb.jdbc.Driver";
String URL = "jdbc:mariadb://localhost:3306/vgc";
String USERNAME = "root";
String PASSWORD = "1234";

Connection con = null;
Statement stmt = null;
ResultSet rs = null;

try {
    Class.forName(DRIVER_CLASS_NAME);
    con = DriverManager.getConnection(URL, USERNAME, PASSWORD);

    String sql = "SELECT seat FROM ticketing ORDER BY ticketingId DESC LIMIT 1"; // 최신 티켓 정보만 가져오기
    stmt = con.createStatement();
    rs = stmt.executeQuery(sql);

    List<String> seatList = new ArrayList<>();

    if (rs.next()) {
        String seats = rs.getString("seat");
        String[] seatsArray = seats.split(", ");
        for (String seat : seatsArray) {
            seatList.add(seat.trim());
        }
    }

    ObjectMapper om = new ObjectMapper();
    out.println(om.writeValueAsString(seatList));
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) {
        try {
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (stmt != null) {
        try {
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (con != null) {
        try {
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>
