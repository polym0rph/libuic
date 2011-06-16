#ifndef UIC_UICONTROLLER_H_QY3EGWKE
#define UIC_UICONTROLLER_H_QY3EGWKE

#include <map>


// typedef to use AXUIElementRef type as a member variable
// taken from AXUIElement.h (HIServices.Framework)
typedef const struct __AXUIElement *AXUIElementRef;


namespace uic
{

/**
 *  The UIController class allows to programmatically control UI element of an 
 *  applications. It provides the functionality to save UI elements, to 
 *  perform a 'PRESS' action and to set the 'AXValue' attribute. The lib uses 
 *  the mac OS-X accessibility API to control other applications
 *  (http://developer.apple.com/library/mac/#documentation/Accessibility/
 *    Reference/AccessibilityLowlevel/AXUIElement_h/CompositePage.html).
 * 
 *  The apple developer tools provide an 'Accessibility Inspector' to explore 
 *  application UI elements, which can be found in: 
 *    /Developer/Applications/Utilities/Accessibility Tools/
 */
class UIController
{
public:
  /**
   *  Ctor.
   */
  UIController();
  
  /**
   *  Dtor.
   */
  ~UIController();

  /**
   *  Enum for different action types. The value of the enum is mapped to an 
   *  action string.
   */
  enum ActionType
  {
    PRESS
  };

  /**
   *  Saves the UI element under the current mouse position in the map with the 
   *  given id.
   *  
   *  @param id The id of the UI element in the map.
   */
  void saveUiElement(unsigned int id);
  
  /**
   *  Performs the given action for the stored UI elment that is identified by 
   *  the given id. Some actions require to switch the focus of the application, 
   *  which can be controlled by the switchFocus parameter.
   *  
   *  @param id The id of the UI element in the map.
   *  @param action The action we want to perform.
   *  @param switchFocus Inicates if we have to swith the focus.
   */
  void performAction(unsigned int id, ActionType action, 
    bool switchFocus = true);
  
  /**
   *  Sets the 'AXValue' attribute of an UI element to the given value.
   * 
   *  @param id The id of the UI element in the map.
   *  @param value The value we want to set.
   */
  void setAttributeValue(unsigned int id, double value);
  
  /**
   *  Removes the UI element with the given id from the map.
   * 
   *  @param id The id of the UI element in the map.
   */
  void removeUIElementWithId(unsigned int id);
  
  /**
   *  Indicates if the map contains an UI element for the given id.
   * 
   *  @param id The id of the UI element in the map.
   */
  bool hasUiElementForId(unsigned int id);
  
private:
  // Returns the max 'AXValue' for the given UI element.
  double axMaxValue(AXUIElementRef element);
  
  // Accessibility object that provides access to system attributes.
  AXUIElementRef mSystemWideElement;
  // Standard map that stores a maaping from ids to UI element references.
  std::map<unsigned int, AXUIElementRef> mUiElementMap;
};

} /* uic */

#endif /* end of include guard: UIC_UICONTROLLER_H_QY3EGWKE */
