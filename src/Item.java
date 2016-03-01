import org.jdom2.Element;

/*
 * Rappresentazione Java di un elemento "item" in un RSS
 */
public class Item
{
	private String title;
	private String description;
	private String link;
	private String date;
	
	public Item(Element e)
	{
		setTitle(e.getChildText("title"));
		setDescription(e.getChildText("description"));
		setLink(e.getChildText("link"));
	}
	
	public String getTitle()
	{
		return title;
	}
	public void setTitle(String title)
	{
		this.title = title;
	}
	public String getDescription()
	{
		return description;
	}
	public void setDescription(String description)
	{
		this.description = description;
	}
	public String getLink()
	{
		return link;
	}
	public void setLink(String link)
	{
		this.link = link;
	}
	public String getDate()
	{
		return date;
	}
	public void setDate(String date)
	{
		this.date = date;
	}
}
