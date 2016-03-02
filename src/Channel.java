import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.Vector;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;

/*
 * Rappresentazione Java dell'elemento "channel" in un file RSS
 */
public class Channel
{
	private String title;
	private String link;
	private String description;
	private int length;
	private Vector<Item> items;
	private int itemsCount;
	
	public Channel(File file)
	{
		SAXBuilder sb = new SAXBuilder();
		Document doc = null;
		items = new Vector<Item>();
		try
		{
			doc = sb.build(file);
			Element root = doc.getRootElement();
			Element channel = root.getChild("channel");
			setTitle(channel.getChildText("title"));
			setLink(channel.getChildText("link"));
			setDescription(channel.getChildText("description"));
			setTitle(channel.getChildText("title"));
			setItems(channel);
			setItemsCount(getItems().size());
		}
		catch(JDOMException e)
		{
			e.printStackTrace();
		}
		catch(IOException e)
		{
			e.printStackTrace();
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

	public String getLink()
	{
		return link;
	}

	public void setLink(String link)
	{
		this.link = link;
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public Vector<Item> getItems()
	{
		return items;
	}

	public void setItems(Vector<Item> items)
	{
		this.items = items;
	}

	public void setItems(Element e)
	{
		Iterator<Element> iIter = e.getChildren("item").iterator();
		while(iIter.hasNext())
		{
			Element ee = iIter.next();
			Item item = new Item(ee); 
			items.add(item);
		}
	}

	public int getLength()
	{
		return length;
	}

	public void setLength(int length)
	{
		this.length = length;
	}

	public int getItemsCount()
	{
		return itemsCount;
	}

	public void setItemsCount(int itemsCount)
	{
		this.itemsCount = itemsCount;
	}

}
