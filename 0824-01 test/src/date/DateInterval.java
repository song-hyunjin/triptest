package date;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/date")
public class DateInterval extends HttpServlet {
	private static final String FORM_VIEW = "./selectdate.jsp";
       
    public DateInterval() {
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect(FORM_VIEW);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, Boolean> errors = new HashMap<String, Boolean>();
		List<String> list = new ArrayList<String>();
 		request.setAttribute("errors", errors);
		
		LocalDate start = LocalDate.parse(request.getParameter("startdate"));
		LocalDate end = LocalDate.parse(request.getParameter("enddate"));
		
		if(start.isBefore(end)) {
			for (int i = 0 ; i <= ChronoUnit.DAYS.between(start, end); i++) {
				list.add(monthDayWeek(start.plusDays(i)));
			}
			request.setAttribute("dateList", list);
		} else if (start.isEqual(end)) {
			request.setAttribute("dateList", monthDayWeek(start));
		} else {
			errors.put("under", Boolean.TRUE);
		}
		
		if (!errors.isEmpty()) {
			request.getRequestDispatcher(FORM_VIEW).forward(request, response);
		} else {
			request.getRequestDispatcher("./dateresult.jsp").forward(request, response);
		}
	}
	
	public String monthDayWeek(LocalDate localDate) {
		String result = "";
		
		result += localDate.getMonth().getValue() + "/" + localDate.getDayOfMonth();
		result += " (" + localDate.getDayOfWeek().getDisplayName(TextStyle.NARROW, Locale.KOREAN) + ")";
		
		return result;
	}
}
