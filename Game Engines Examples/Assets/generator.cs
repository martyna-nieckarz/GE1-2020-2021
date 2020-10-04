using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class generator : MonoBehaviour
{
    public int rings = 9;

    public int diameterOfPrefab = 1;
    public GameObject shape;
    // Start is called before the first frame update
    void Start()
    {
        for(int r = 1; r < rings; r++){
            int diameter = 2 * r;
            int circum = (int) (Mathf.PI * diameter);
            int elem = circum / diameterOfPrefab;
            float theta = Mathf.PI * 2.0f / (float) elem;
            
            for (int i = 0; i < elem; i++){
                GameObject sp = Instantiate(shape);

                float x = Mathf.Sin(theta * i) * r;
                float z = Mathf.Cos(theta * i) * r;
                
                Vector3 pos = new Vector3(x, 0, z);
                //Vector3 pos = new Vector3(Mathf.Sin(theta * i) * r, 0, Mathf.Cos(theta * i) * r);
                sp.transform.position = transform.TransformPoint(pos);
            }
        }
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

