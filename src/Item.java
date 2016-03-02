import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.jdom2.Element;

/*
 * Rappresentazione Java di un elemento "item" in un RSS
 */
public class Item
{
	private String title;
	private String channelTitle;
	private String description;
	private String link;
	private Date date;
	private int length;
	
	public Item(Element e)
	{
		try
		{
			setTitle(e.getChildText("title"));
			setDescription(e.getChildText("description"));
			setLink(e.getChildText("link"));
			SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
			setDate(sdf.parse(e.getChildText("pubDate")));
			setChannelTitle(e.getParentElement().getChildText("title"));
		}
		catch(ParseException e1)
		{
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
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

	public Date getDate()
	{
		return date;
	}

	public void setDate(Date date)
	{
		this.date = date;
	}

	public int getLength()
	{
		return length;
	}

	public void setLength(int length)
	{
		this.length = length;
	}

	public String getChannelTitle()
	{
		return channelTitle;
	}

	public void setChannelTitle(String channelTitle)
	{
		this.channelTitle = channelTitle;
	}
}
