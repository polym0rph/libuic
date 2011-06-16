#include <Cocoa/Cocoa.h>

#include <iostream>

#include "UIController.h"


namespace uic
{

UIController::UIController()
  : mSystemWideElement(NULL)
{
  mSystemWideElement = AXUIElementCreateSystemWide();
}

UIController::~UIController()
{
  CFRelease(mSystemWideElement);

  std::map<unsigned int, AXUIElementRef>::iterator it;
  for(it = mUiElementMap.begin(); it != mUiElementMap.end(); it++)
    CFRelease((*it).second);
}

void UIController::saveUiElement(unsigned int pId)
{
  // get current mouse location
  CGPoint curloc;
  CGEventRef eventRef;

  eventRef = CGEventCreate(NULL);
  curloc = CGEventGetLocation(eventRef);
  CFRelease(eventRef);

  std::cout << "Current mouse pointer location - x: " << curloc.x << " y: "
    << curloc.y << std::endl;

  // get UI element at the current position and save it in the map
  AXUIElementRef newElement = NULL;
  AXError copyElementError = AXUIElementCopyElementAtPosition(
    mSystemWideElement, curloc.x, curloc.y, &newElement);

  if(copyElementError == kAXErrorSuccess)
  {
    mUiElementMap[pId] = newElement;
    std::cout << "Saved UI elment in map with key: " << pId << std::endl;
  }
  else
  {
    CFRelease(newElement);
    std::cout << "AXUIElementCopyElementAtPosition failed with error code: "
      << copyElementError << std::endl;
  }
}

void UIController::performAction(unsigned int pId, ActionType pAction, 
  bool pSwitchFocus)
{  
  std::map<unsigned int, AXUIElementRef>::iterator it;
  it = mUiElementMap.find(pId);
  if(it != mUiElementMap.end())
  {
    // TODO: Replace ProcessManager Carbon APIs
    ProcessSerialNumber own;
    if(pSwitchFocus)
    {
      // get current porcess serial number
      GetCurrentProcess(&own);

      // get the pid to which the ui element belongs
      pid_t pid;
      AXUIElementGetPid(it->second, &pid);

      ProcessSerialNumber other;
      GetProcessForPID(pid, &other);

      // switch focus
      SetFrontProcess(&other);
    }

    CFStringRef actionName = NULL;
    if(pAction == PRESS)
      actionName = CFSTR("AXPress");

    // TODO: check if the ui element can perform the specified action
    // get all actions for the ui element
    // NSArray * actionNames;
    // AXUIElementCopyActionNames(mCurrentElement, (CFArrayRef *)&actionNames);
    // 
    // unsigned int numberOfActions = [actionNames count];
    // 
    // std::cout << "number of actions: " << numberOfActions << std::endl;
    //   
    // for(size_t i = 0; i < numberOfActions; ++i)
    // {
    //   NSString * theName = NULL;
    //   theName = [actionNames objectAtIndex:i];
    //   
    //   std::cout << [theName UTF8String] << std::endl;
    // }

    if(actionName != NULL)
    {
      AXError performActionError = AXUIElementPerformAction(it->second,
        actionName);

      if(performActionError == kAXErrorSuccess)
        std::cout << "Performed action " << pAction << std::endl;
      else
        std::cout << "AXUIElementPerformAction failed with error code "
          << performActionError << std::endl;
    }
    else
    {
      std::cout << "Not a valid action" << std::endl;
    }

    if(pSwitchFocus)
    {
      // switch focus back
      SetFrontProcess(&own);
    }
  }
  else
  {
    std::cout << "The given key: " << pId << " is not in the map" << std::endl;
  }
}

void UIController::setAttributeValue(unsigned int pId, double pValue)
{
  std::map<unsigned int, AXUIElementRef>::iterator it;
  it = mUiElementMap.find(pId);
  if(it != mUiElementMap.end())
  {
    double value = pValue * axMaxValue(it->second);

    // TODO: check if the value is settable
    AXError setAttributeValueError = AXUIElementSetAttributeValue(it->second,
      CFSTR("AXValue"), [NSNumber numberWithDouble:value]);

    if(setAttributeValueError == kAXErrorSuccess)
      std::cout << "Set  attribute value to " << value << std::endl;
    else
      std::cout << "AXUIElementSetAttributeValue failed with error code "
        << setAttributeValueError << std::endl;
  }
  else
  {
    std::cout << "The given key: " << pId << " is not in the map" << std::endl;
  }
}

void UIController::removeUIElementWithId(unsigned int pId)
{
  AXUIElementRef currentElement = mUiElementMap[pId];
  if(currentElement != NULL)
    CFRelease(currentElement);

  mUiElementMap.erase(pId);
  std::cout << "Removing item with key: " << pId << std::endl;
}

bool UIController::hasUiElementForId(unsigned int pId)
{
  if(mUiElementMap.find(pId) == mUiElementMap.end())
    return false;
  return true;
}


double UIController::axMaxValue(AXUIElementRef pElement)
{
  double value = 1;
  id result = nil;

  AXError copyAttributeValueError = AXUIElementCopyAttributeValue(pElement,
    CFSTR("AXMaxValue"), (CFTypeRef *)&result);

  if(copyAttributeValueError == kAXErrorSuccess)
  {
    if([result isKindOfClass:[NSNumber class]] == YES)
      value = [(NSNumber *)result doubleValue];

    std::cout << "Got attribute value: " << value << std::endl;

    CFRelease(result);
  }
  else
  {
    std::cout << "AXUIElementCopyAttributeValue failed with error code "
      << copyAttributeValueError << std::endl;
  }

  return value;
}

} /* uic */ 
