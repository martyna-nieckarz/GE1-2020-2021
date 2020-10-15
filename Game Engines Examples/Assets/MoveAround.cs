using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

public class MoveAround : MonoBehaviour
{
    // Start is called before the first frame update
    public Transform player;
    public int radius = 10;
    public int speed = 3;
    public float lookSpeed = 3f;
    public int waypointsAmount = 30;
    public GameObject waypointOb;
    private List<GameObject> waypointList = new List<GameObject>();
    private int waypointIndex = -1;
    private Transform target;
    private static StringBuilder message = new StringBuilder();
    private float dist;
    void Start()
    {
        createWayPoints();
        selectNextTarget();
    }

    public void OnGUI()
    {
        GUI.color = Color.black;
        GUI.Label(new Rect(0, 0, Screen.width, Screen.height), "" + message);
        if (Event.current.type == EventType.Repaint)
        {
            message.Length = 0;
        }
    }

    void selectNextTarget() {
        waypointIndex = (waypointIndex + 1) % waypointList.Count;
        this.target = waypointList[waypointIndex].transform;
        this.dist = (target.transform.position - transform.position).magnitude;
    }

    void createWayPoints() {
        // angle 2 pi = 360 
        float theta = Mathf.PI * 2.0f / (float) waypointsAmount;
        for(int i = 0 ; i < waypointsAmount ; i ++) {
            GameObject sp = GameObject.Instantiate<GameObject>(waypointOb);

            //float x = Mathf.Sin(theta * i) * radius;
            //float y = Mathf.Cos(theta * i) * radius;
            //Vector3 pos = new Vector3(x, 0, z); // vector is x y z

            Vector3 pos = new Vector3(Mathf.Sin(theta * i) * radius, 0, Mathf.Cos(theta * i) * radius);
            sp.transform.position = transform.TransformPoint(pos);

            waypointList.Add(sp);
        }

        foreach(GameObject sp in waypointList) { 
            print(sp.transform.position);
        }
    }

    void slowLookAt() {
        Vector3 lookTargetDirection = this.target.position - transform.position;
        lookTargetDirection.y = 0.0f;
        transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(lookTargetDirection), lookSpeed);
    }

    // Update is called once per frame
    void Update()
    {
        // Get distance between the next target and the red tank
        this.dist = (target.position - transform.position).magnitude;
        Vector3 toTarget = target.position - transform.position;
        toTarget.Normalize();

        // If the destination/target was not reached
        if (dist > 0.1f){
            // Move closer
            transform.position += toTarget * speed * Time.deltaTime;
            slowLookAt();

        } else {
            selectNextTarget();
        }
    
        Vector3 playerToTarget = player.position - transform.position;

        float dot = Vector3.Dot(transform.forward, playerToTarget);
        float angle = Vector3.Angle(transform.forward, playerToTarget);
        
        // This method of obtaining the angle does not appear to work
        float angle2 = Mathf.Acos(dot) * Mathf.Rad2Deg;

        // Not entirely sure how the dot product of the two determines whether
        // one is in front of the other but I honestly don't have time to find out
        if (dot >= 0) {
            message.Append("Player is in front");
        } else {
            message.Append("Player is behind");
        }

        // Check if player is within 45 degrees of field of view
        if (angle >= 0 && angle <= 45) {
            message.Append("\n" + "Player within 45 degrees FOV");
        } else {
            message.Append("\n" + "Player outside 45 degrees FOV");
        }
    }
}