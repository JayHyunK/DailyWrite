package DailyWrite_Java;

public class EmotionContent {

	public String suggestText(String emotion) {
		
		String tag = "";
		tag = "<ul class='St-conul'>";
		tag	+= "<li class='St-conli'>";
		tag	+= "<a href='";
		tag	+= TextContentAnchor1(emotion);
		tag	+= "'><span class='St-conimg'><img src='";
		tag	+= TextContentImage1(emotion);
		tag	+= "' class='St-conliimg'></a></li><li class='St-conliBetween'></li>";
		tag	+= "<li class='St-conli'>";
		tag	+= "<a href='";
		tag	+= TextContentAnchor2(emotion);
		tag	+= "'><span class='St-conimg'><img src='";
		tag	+= TextContentImage2(emotion);
		tag	+= "' class='St-conliimg'></a></li><li class='St-conliBetween'></li>";
		tag	+= "<li class='St-conli'>";
		tag	+= "<a href='";
		tag	+= TextContentAnchor3(emotion);
		tag	+= "'><span class='St-conimg'><img src='";
		tag	+= TextContentImage3(emotion);
		tag	+= "' class='St-conliimg'></a></li><li class='St-conliBetween'></li></ul>";
		System.out.println(tag);
		return tag;
	}
	
	public String suggestMusic(String emotion) {
		
		String tag = "";
		tag = "<ul class='St-conul'>"
			+ "<li class='St-conli'>"
			+ "<a href='"
			+ MusicContentAnchor1(emotion)
			+ "'><span class='St-conimg'><img src='"
			+ MusicContentImage1(emotion)	
			+ "' class='St-conliimg'></a></li><li class='St-conliBetween'></li>"
			+ "<li class='St-conli'>"
			+ "<a href='"
			+ MusicContentAnchor2(emotion)
			+ "'><span class='St-conimg'><img src='"
			+ MusicContentImage2(emotion)		
			+ "' class='St-conliimg'></a></li><li class='St-conliBetween'></li>"
			+ "<li class='St-conli'>"
			+ "<a href='"
			+ MusicContentAnchor3(emotion)
			+ "'><span class='St-conimg'><img src='"
			+ MusicContentImage3(emotion)	
			+ "' class='St-conliimg'></a></li><li class='St-conliBetween'></li></ul>";
		System.out.println(tag);
		return tag;
	}
	public String TextContentAnchor1(String emotion) {
		String url="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			url = "https://pixabay.com/ko/images/search/peace/";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			url = "https://pixabay.com/ko/images/search/love/";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			url = "https://pixabay.com/ko/images/search/whale/";
		}
		if(emotion.equals("soso")) {
			url = "https://pixabay.com/ko/images/search/trip/";
		}
		if(emotion.equals("trashcan")) {
			url = "https://pixabay.com/ko/images/search/mom/";
		}
		
		return url;
	}
	public String TextContentAnchor2(String emotion) {
		String url="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			url = "https://pixabay.com/ko/images/search/bear/";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			url = "https://pixabay.com/ko/photos/search/duck/";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			url = "https://pixabay.com/ko/images/search/puppy/";
		}
		if(emotion.equals("soso")) {
			url = "https://pixabay.com/ko/images/search/cat/";
		}
		if(emotion.equals("trashcan")) {
			url = "https://pixabay.com/ko/images/search/family%20sunset/";
		}
		
		return url;
	}
	public String TextContentAnchor3(String emotion) {
		String url="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			url = "https://pixabay.com/ko/images/search/beach/";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			url = "https://pixabay.com/ko/images/search/ice%20cream/";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			url = "https://pixabay.com/ko/images/search/family%20sunset/";
		}
		if(emotion.equals("soso")) {
			url = "https://pixabay.com/ko/images/search/sky/";
		}
		if(emotion.equals("trashcan")) {
			url = "https://pixabay.com/ko/images/search/i%20love%20you/";
		}
		
		return url;
	}
	public String TextContentImage1(String emotion) {
		String src="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			src="./images/water.jpg";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			src="./images/heart.jpg";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			src="./images/thewhale.jpg";
		}
		if(emotion.equals("soso")) {
			src="./images/winding-road-1556177_640.jpg";
		}
		if(emotion.equals("trashcan")) {
			src="./images/child-5033381_640.jpg";
		}
		
		return src;
	}
	public String TextContentImage2(String emotion) {
		String src="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")|emotion.equals("fun")) {
			src="./images/teddy-bear-524251_640.jpg";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			src="./images/mallard-3524213_640.jpg";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			src="./images/dog-4390885_640.jpg";
		}
		if(emotion.equals("soso")) {
			src="./images/cat-6463284_640.jpg";
		}
		if(emotion.equals("trashcan")) {
			src="./images/walking-together-2458572_640.jpg";
		}
		
		return src;
	}
	public String TextContentImage3(String emotion) {
		String src="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			src="./images/boardwalk-569314_640.jpg";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			src="./images/ice.jpg";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			src="./images/silhouette-3230374_640.jpg";
		}
		if(emotion.equals("soso")) {
			src="./images/field-533541_640.jpg";
		}
		if(emotion.equals("trashcan")) {
			src="./images/roses-2840765_640.jpg";
		}
		
		return src;
	}
	
	public String MusicContentAnchor1(String emotion) {
		String url="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			url = "https://www.youtube.com/watch?v=DGDyAb6pePo";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			url = "https://www.youtube.com/watch?v=jO2viLEW-1A";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			url = "https://www.youtube.com/watch?v=hWOB5QYcmh0";
		}
		if(emotion.equals("soso")) {
			url = "https://www.youtube.com/watch?v=DGDyAb6pePo";
		}
		if(emotion.equals("trashcan")) {
			url = "https://www.youtube.com/watch?v=TzFRVk2ektI";
		}
		return url;
	}
	public String MusicContentAnchor2(String emotion) {
		String url="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			url = "https://www.youtube.com/watch?v=TzFRVk2ektI";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			url = "https://www.youtube.com/watch?v=VXzAJd8UJl8";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			url = "https://www.youtube.com/watch?v=dTwj7PhpY9M";
		}
		if(emotion.equals("soso")) {
			url = "https://www.youtube.com/watch?v=CRHPclhtlN0";
		}
		if(emotion.equals("trashcan")) {
			url = "https://www.youtube.com/watch?v=amOSaNX7KJg";
		}
		
		return url;
	}
	public String MusicContentAnchor3(String emotion) {
		String url="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			url = "https://www.youtube.com/watch?v=-xOiKNFcbfU";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			url = "https://www.youtube.com/watch?v=r-Z8KuwI7Gc";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			url = "https://www.youtube.com/watch?v=Ty8UzZlO1EE";
		}
		if(emotion.equals("soso")) {
			url = "https://www.youtube.com/watch?v=tAXjTnKQi8w";
		}
		if(emotion.equals("trashcan")) {
			url = "https://www.youtube.com/watch?v=zpIgoy3Q1OE";
		}
		
		return url;
	}
	public String MusicContentImage1(String emotion) {
		String src="";
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			src="./images/graffiti-wall-1209761_640.jpg";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			src="./images/abstract-2468874_640.jpg";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			src="./images/animal-3546613_640.jpg";
		}
		if(emotion.equals("soso")) {
			src="./images/renovation-1262389_640.png";
		}
		if(emotion.equals("trashcan")) {
			src="./images/eye-4453129_640.jpg";
		}
		
		return src;
	}
	public String MusicContentImage2(String emotion) {
		String src="";
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			src="./images/house-5650705_640.jpg";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			src="./images/color-5821297_640.jpg";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			src="./images/green-5919790_640.jpg";
		}
		if(emotion.equals("soso")) {
			src="./images/glass-5650335_640.jpg";
		}
		if(emotion.equals("trashcan")) {
			src="./images/poppy-6206112_640.jpg";
		}
		
		return src;
	}
	public String MusicContentImage3(String emotion) {
		String src="";
		
		if(emotion.equals("happy")||emotion.equals("exciting")||emotion.equals("fun")) {
			src="./images/daisies-6286585_640.jpg";
		}
		if(emotion.equals("worried")||emotion.equals("sad")) {
			src="./images/jackie-matthews-photography-6079016_640.jpg";
		}
		if(emotion.equals("upset")||emotion.equals("angry")) {
			src="./images/coffee-6371149_640.jpg";
		}
		if(emotion.equals("soso")) {
			src="./images/rufous-6476117_640.jpg";
		}
		if(emotion.equals("trashcan")) {
			src="./images/crown-anemone-6157488_640.jpg";
		}
		
		return src;
	}
}
