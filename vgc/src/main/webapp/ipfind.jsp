<%@ page import="java.sql.*" %>
<%@ page contentType="text/plain;charset=UTF-8" language="java" %>

<%
response.setHeader("Access-Control-Allow-Origin","*");

// 데이터베이스 연결 정보
String DRIVER_CLASS_NAME = "org.mariadb.jdbc.Driver";
String URL = "jdbc:mariadb://localhost:3306/vgc";
String USERNAME = "root";
String PASSWORD = "1234";

// 클라이언트에서 전송한 이메일
String email = request.getParameter("email");

// 이메일에 해당하는 비밀번호 조회 쿼리
String query = "SELECT userPassword FROM joinup WHERE userEmail = ?";

Connection connection = null;
PreparedStatement statement = null;
ResultSet resultSet = null;

try {
    // 데이터베이스 연결
    Class.forName(DRIVER_CLASS_NAME);
    connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

    // 쿼리 실행
    statement = connection.prepareStatement(query);
    statement.setString(1, email);
    resultSet = statement.executeQuery();

    if (resultSet.next()) {
        // 이메일에 해당하는 비밀번호를 클라이언트로 전송
        String foundPassword = resultSet.getString("userPassword");
        out.println("비밀번호는 " + foundPassword + " 입니다.");
    } else {
        // 해당 이메일이 없는 경우
        out.println("존재하지 않는 이메일입니다.");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    // 연결 및 자원 해제
    try {
        if (resultSet != null) resultSet.close();
        if (statement != null) statement.close();
        if (connection != null) connection.close();
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
}
%>