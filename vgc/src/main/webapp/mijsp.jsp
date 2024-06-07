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

    String sql = "SELECT seat FROM ticketing"; // 모든 티켓 정보 가져오기
    stmt = con.createStatement();
    rs = stmt.executeQuery(sql);

    List<String> disabledSeats = new ArrayList<>(); // 비활성화된 좌석을 저장할 리스트

    while (rs.next()) {
        String seats = rs.getString("seat");
        String[] seatsArray = seats.split(", ");
        for (String seat : seatsArray) {
            disabledSeats.add(seat.trim()); // 비활성화된 좌석 추가
        }
    }

    ObjectMapper om = new ObjectMapper();
    out.println(om.writeValueAsString(disabledSeats));
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
