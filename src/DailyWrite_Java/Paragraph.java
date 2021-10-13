package DailyWrite_Java;

public class Paragraph {
	
	private String num;
	private String id;
	private String name;
	private String date;
	private String title;
	private String content;
	private String file;
	private String view;
	private String emotion;
	
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	
	public String getEmotion() {
		return emotion;
	}
	public void setEmotion(String emotion) {
		this.emotion = emotion;
	}
	public String getView() {
		return view;
	}
	public void setView(String view) {
		this.view = view;
	}
	public String getFile() {
		return file;
	}
	public void setFile(String file) {
		this.file = file;
	}
	
	public String checkEmotion(String str) {
		String check = "";
		if(str.equals("happy")) {
			check="<img src='./icon/happyColor.png' style='width:1.3vw'>";
		}
		else if(str.equals("fun")) {
			check="<img src='./icon/funColor.png' style='width:1.3vw'>";		
		}
		else if(str.equals("exciting")) {
			check="<img src='./icon/excitingColor.png' style='width:1.3vw'>";
		}
		else if(str.equals("soso")) {
			check="<img src='./icon/sosoColor.png' style='width:1.3vw'>";
		}
		else if(str.equals("worried")) {
			check="<img src='./icon/worriedColor.png' style='width:1.3vw'>";
		}
		else if(str.equals("upset")) {
			check="<img src='./icon/upsetColor.png' style='width:1.3vw'>";
		}
		else if(str.equals("sad")) {
			check="<img src='./icon/sadColor.png' style='width:1.3vw'>";
		}
		else if(str.equals("angry")) {
			check="<img src='./icon/angryColor.png' style='width:1.3vw'>";
		}
		else if(str.equals("trashcan")) {
			check="<img src='./icon/trashcanColor.png' style='width:1.3vw'>";
		}
			
		return check;
	}
	
}
